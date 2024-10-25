import express from "express";
import {
  authUser,
  registerUser,
  logoutUser,
} from "../controllers/userController.js";
import { authMiddleware } from "../middleware/authMiddleware.js";
// - **POST /api/users** - Register a user
// - **POST /api/users/auth** - Authenticate a user and get token
// - **POST /api/users/logout** - Logout user and clear cookie

const router = express.Router();

router.post("/", registerUser);
router.post("/auth", authUser);
router.post("/logout", authMiddleware, logoutUser);

export default router;
