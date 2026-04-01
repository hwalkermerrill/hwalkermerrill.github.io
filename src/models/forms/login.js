// Imports
import bcrypt from "bcrypt";
import db from "../db.js";

const findUserByUsername = async (username) => {
  const query = `
    SELECT u.id,
      u.name,
      u.email,
      u.password,
      u.created_at,
      r.role_name AS "roleName"
    FROM users AS u
    INNER JOIN roles AS r ON u.role_id = r.id 
    WHERE LOWER(u.name) = LOWER($1) LIMIT 1
  `;

  const result = await db.query(query, [username]);
  return result.rows[0] || null;
};

const verifyPassword = async (plainPassword, hashedPassword) => {
  const verified = await bcrypt.compare(plainPassword, hashedPassword);
  return verified;
};

export { findUserByUsername, verifyPassword };