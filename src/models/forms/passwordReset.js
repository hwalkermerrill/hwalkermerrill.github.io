// Imports
import db from "../db.js";

const findUserByNameAndUsername = async (full_name, username) => {
  const result = await db.query(
    `
    SELECT id, full_name, username
    FROM users
    WHERE full_name = $1 
      AND username = $2`,
    [full_name, username]
  );
  return result.rows[0] || null;
};

const createResetRequest = async (userId) => {
  const result = await db.query(
    `
    INSERT INTO password_reset_requests (user_id, status)
    VALUES ($1, 'submitted')
    RETURNING *`,
    [userId]
  );
  return result.rows[0];
};

const getAllResetRequestsWithUser = async () => {
  const result = await db.query(
    `
    SELECT pr.id,
          pr.user_id,
          pr.status,
          pr.requested_at,
          pr.approved_at,
          pr.completed_at,
          pr.reset_code,
          u.full_name,
          u.username
    FROM password_reset_requests pr
    JOIN users u ON pr.user_id = u.id
    ORDER BY pr.requested_at DESC`
  );
  return result.rows;
};

const approveResetRequest = async (requestId, resetCode, expiresAt) => {
  const result = await db.query(
    `
    UPDATE password_reset_requests
    SET status = 'approved',
        reset_code = $2,
        approved_at = NOW(),
        expires_at = $3
    WHERE id = $1
    RETURNING *`,
    [requestId, resetCode, expiresAt]
  );
  return result.rows[0] || null;
};

const denyResetRequest = async (requestId) => {
  const result = await db.query(
    `
    UPDATE password_reset_requests
    SET status = 'denied'
    WHERE id = $1
    RETURNING *`,
    [requestId]
  );
  return result.rows[0] || null;
};

const findApprovedRequestForUser = async (username, resetCode) => {
  const result = await db.query(
    `
    SELECT pr.*, u.id AS user_id, u.username
    FROM password_reset_requests pr
    JOIN users u ON pr.user_id = u.id
    WHERE u.username = $1
      AND pr.reset_code = $2
      AND pr.status = 'approved'
      AND (pr.expires_at IS NULL OR pr.expires_at > NOW())
    ORDER BY pr.requested_at DESC
    LIMIT 1`,
    [username, resetCode]
  );
  return result.rows[0] || null;
};

const completeResetRequest = async (requestId) => {
  const result = await db.query(
    `
    UPDATE password_reset_requests
    SET status = 'completed',
        completed_at = NOW()
    WHERE id = $1
    RETURNING *`,
    [requestId]
  );
  return result.rows[0] || null;
};

const updateUserPassword = async (userId, hashedPassword) => {
  await db.query(
    `
    UPDATE users
    SET password_hash = $2
    WHERE id = $1`,
    [userId, hashedPassword]
  );
};

export { findUserByNameAndUsername, createResetRequest, getAllResetRequestsWithUser, approveResetRequest, denyResetRequest, findApprovedRequestForUser, completeResetRequest, updateUserPassword };