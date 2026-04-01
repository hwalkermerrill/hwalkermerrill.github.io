// Imports
import db from "../db.js";

/**
 * Checks if a user name is already registered in the database.
 * 
 * @param {string} username - The user name to check
 * @returns {Promise<boolean>} True if username exists, false otherwise
 */
const usernameExists = async (username) => {
  const query = `
      SELECT EXISTS(SELECT 1 FROM users WHERE username = $1) as exists
    `;
  const result = await db.query(query, [username]);
  return result.rows[0].exists;
};

/**
 * Saves a new user to the database with a hashed password.
 * 
 * @param {string} name - The user's full name
 * @param {string} username - The user's username
 * @param {string} hashedPassword - The bcrypt-hashed password
 * @returns {Promise<Object>} The newly created user record (without password)
 */
const saveUser = async (name, username, hashedPassword) => {
  const query = `
      INSERT INTO users (name, username, password)
      VALUES ($1, $2, $3)
      RETURNING id, name, username, created_at
    `;
  const result = await db.query(query, [name, username, hashedPassword]);
  return result.rows[0];
};

/**
 * Retrieves all registered users from the database.
 * 
 * @returns {Promise<Array>} Array of user records (without passwords)
 */
const getAllUsers = async () => {
  const query = `
      SELECT id, name, username, created_at
      FROM users
      ORDER BY created_at DESC
    `;
  const result = await db.query(query);
  return result.rows;
};

/**
 * Retrieve a single user by ID with role information
 */
const getUserById = async (id) => {
  const query = `
      SELECT 
        users.id,
        users.name,
        users.email,
        users.created_at,
        roles.role_name AS "roleName"
      FROM users
      INNER JOIN roles ON users.role_id = roles.id
      WHERE users.id = $1
    `;
  const result = await db.query(query, [id]);
  return result.rows[0] || null;
};

/**
 * Update a user's name and username
 */
const updateUser = async (id, name, username) => {
  const query = `
      UPDATE users 
      SET name = $1, username = $2, updated_at = CURRENT_TIMESTAMP
      WHERE id = $3
      RETURNING id, name, username, updated_at
    `;
  const result = await db.query(query, [name, username, id]);
  return result.rows[0] || null;
};

/**
 * Delete a user account
 */
const deleteUser = async (id) => {
  const query = "DELETE FROM users WHERE id = $1";
  const result = await db.query(query, [id]);
  return result.rowCount > 0;
};

export { usernameExists, saveUser, getAllUsers, getUserById, updateUser, deleteUser };