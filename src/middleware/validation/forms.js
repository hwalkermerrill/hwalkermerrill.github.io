// Imports
import { body } from "express-validator";

// Process Invitation Code
const INVITE_CODE = process.env.INVITE_CODE

// Validation Arrays
const registrationValidation = [
  body("name")
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage("Name must be at least 2 characters and no more than 100 characters")
    .matches(/^[a-zA-Z\s'-]+$/)
    .withMessage("Name can only contain letters, spaces, hyphens, and apostrophes'"),
  body("inviteCode")
    .trim()
    .custom((value) => {
      return INVITE_CODE && INVITE_CODE.trim() !== "" && value === INVITE_CODE;
    })
    .withMessage("Invalid invitation code"),
  body("username")
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage("Username must be at least 2 characters and no more than 100 characters")
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage("Username can only contain letters, numbers, and underscores"),
  body("usernameConfirm")
    .trim()
    .custom((value, { req }) => value === req.body.username)
    .withMessage("Usernames must match"),
  body("password")
    .trim()
    .isLength({ min: 8 })
    .withMessage("Password must be at least 8 characters")
    .isLength({ max: 128 })
    .withMessage("Password must be less than 129 characters")
    .matches(/[0-9]/)
    .withMessage("Password must contain at least one number")
    .matches(/[a-z]/)
    .withMessage("Password must contain at least one lowercase letter")
    .matches(/[A-Z]/)
    .withMessage("Password must contain at least one uppercase letter")
    .matches(/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/) // eslint-disable-line no-useless-escape
    .withMessage("Password must contain at least one special character"),
  body("passwordConfirm")
    .trim()
    .custom((value, { req }) => value === req.body.password)
    .withMessage("Passwords must match")
];

const loginValidation = [
  body("username")
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage("Username must be at least 2 characters and no more than 100 characters")
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage("Username can only contain letters, numbers, and underscores"),
  body("password")
    .trim()
    .isLength({ min: 8 })
    .withMessage("Password must be at least 8 characters")
    .isLength({ max: 128 })
    .withMessage("Password must be less than 129 characters")
];

const updateAccountValidation = [
  body("name")
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage("Name must be between 2 and 100 characters")
    .matches(/^[a-zA-Z\s'-]+$/)
    .withMessage("Name can only contain letters, spaces, hyphens, and apostrophes"),
  body("username")
    .trim()
    .isLength({ min: 2, max: 100 })
    .withMessage("Username must be at least 2 characters and no more than 100 characters")
    .matches(/^[a-zA-Z0-9_]+$/)
    .withMessage("Username can only contain letters, numbers, and underscores")
];

const contactValidation = [
  body("subject")
    .trim()
    .isLength({ min: 2, max: 255 })
    .withMessage("Subject must be at least 2 characters and no more than 255 characters")
    .matches(/^[a-zA-Z0-9\s\-.,!?]+$/)
    .withMessage("Subject contains invalid characters"),
  body("message")
    .trim()
    .isLength({ min: 10, max: 2000 })
    .withMessage("Message must be at least 10 characters and no more than 2000 characters")
    .custom((value) => {
      // Check for spam patterns (repetition)
      const words = value.split(/\s+/);
      const uniqueWords = new Set(words);
      if (words.length > 20 && uniqueWords.size / words.length < 0.3) {
        throw new Error("Message appears to be spam");
      }
      return true;
    })
];

export { registrationValidation, loginValidation, updateAccountValidation, contactValidation };