import jwt from "jsonwebtoken";
import asyncHandler from "express-async-handler";
import User from "../models/userModel.js";

const authMiddleware = asyncHandler(async (req, res, next) => {
  let token;

  // Check if authorization header exists and starts with "Bearer"
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      // Extract the token
      token = req.headers.authorization.split(" ")[2];
      if (token) {
        // Verify token
        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

        if (!decoded) {
          return res.status(401).json({ status: "Token verification failed" });
        }

        // Find user by email decoded from the token
        const email = decoded.useremail;
        const user = await User.findOne({ email });

        if (!user) {
          return res.status(404).json({ status: "User not found" });
        }

        // Attach user to request object
        req.user = user;
        next();
      } else {
        res.status(400).json({ status: "Token is empty" });
      }
    } catch (error) {
      // Token verification error
      return res
        .status(401)
        .json({ status: "Invalid token", error: error.message });
    }
  } else {
    res
      .status(400)
      .json({
        status: "Authorization token missing or not properly formatted",
      });
  }
});

export { authMiddleware };
