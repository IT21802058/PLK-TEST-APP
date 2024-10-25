import asyncHandler from "express-async-handler";
import User from "../models/userModel.js";
import {
  generateAccessToken,
  generateRefreshToken,
} from "../utils/generateToken.js";
import bcrypt from "bcryptjs";

// @desc    Register a new user
// route    POST /api/users/
// @access  Public
const registerUser = asyncHandler(async (req, res) => {
  const {
    firstName,
    lastName,
    email,
    phoneNo,
    userType,
    password,
    confirmPassword,
  } = req.body;

  const newUser = new User({
    firstName,
    lastName,
    email,
    phoneNo,
    userType,
    password,
  });

  if (password == confirmPassword) {
    await newUser
      .save()
      .then(() => {
        res
          .status(201)
          .send({ status: "User Added Successfully", user: newUser });
      })
      .catch((error) => {
        console.log(error);
        res.status(500).send({ status: "You already have a account" });
      });
  } else {
    res.status(412).send({ status: "Password miss match" });
  }
});

// @desc    Auth user & set token
// route    POST /api/users/auth
// @access  Public
const authUser = asyncHandler(async (req, res) => {
  const { email, password } = req.body;
  try {
    const loguser = await User.findOne({ email });

    if (!loguser) {
      return res.status(404).send({ status: "User not found" });
    }

    // Await the result of bcrypt.compare
    const comparedpassword = await bcrypt.compare(password, loguser.password);

    if (comparedpassword) {
      const userlogtype = loguser.userType;
      const userId = loguser._id;
      const loggertype = { useremail: email, userType: userlogtype };

      // Generate tokens
      const accessToken = generateAccessToken(loggertype);
      const refreshToken = generateRefreshToken(loggertype);

      // Return success response with tokens
      res.status(200).send({
        status: "User logged in successfully",
        accessToken,
        userId,
        userlogtype,
      });
    } else {
      // Password did not match
      res.status(412).send({ status: "User password is incorrect" });
    }
  } catch (error) {
    // Catch any errors and return a server error response
    res.status(500).send({
      status: "Error with logging functionality",
      error: error.message,
    });
  }
});

// @desc    Logout user
// route    POST /api/users/logout
// @access  Public
const logoutUser = asyncHandler(async (req, res) => {
  const { email } = req.body;

  await User.findOneAndUpdate({ email }, { $set: { refreshToken: null } })
    .then(() => {
      res.cookie("jwt", "", {
        httpOnly: true,
        expires: new Date(0),
      });
      res.status(200).send({ status: "Logged out successfully" });
    })
    .catch((error) => {
      console.log(error);
      res.status(500).send({ status: "Error with logout functionality" });
    });
});

export {
  authUser,
  registerUser,
  logoutUser,
};
