// This util sets the permissions of each role

// Permission Definitions
const ROLE_PERMISSIONS = {
  user: [
    // Users
    "view_self",
    "edit_self",
    "edit_owned",
    "delete_owned",

    // Notes
    "view_notes",
    "create_notes",

    // Characters
    "create_pc",
    "create_companion"
  ],

  moderator: [
    // Inherit all user permissions
    "view_self",
    "edit_self",
    "edit_owned",
    "delete_owned",
    "view_notes",
    "create_notes",
    "create_pc",
    "create_companion",

    // Moderator-level permissions
    "view_users",
    "moderate_content",

    // Moderator Creations
    "create_logs",

    // Moderator Edits
    "edit_notes",
    "edit_logs",
    "edit_pc",
    "edit_companion",
    "edit_npc",
    "edit_items"
  ],

  gm_admin: [
    // Inherit moderator permissions
    "view_self",
    "edit_self",
    "edit_owned",
    "delete_owned",
    "view_notes",
    "create_notes",
    "create_pc",
    "create_companion",
    "view_users",
    "moderate_content",
    "create_logs",
    "edit_notes",
    "edit_logs",
    "edit_pc",
    "edit_companion",
    "edit_npc",
    "edit_items",

    // Admin-level permissions
    "edit_users",
    "approve_password_resets",

    // Admin creations
    "create_npc",
    "create_items",

    // Admin deletions
    "delete_users",
    "delete_notes",
    "delete_logs",
    "delete_pc",
    "delete_companion",
    "delete_npc",
    "delete_items",

    // Admin management
    "manage_campaign",
    "manage_maps",
    "manage_locations",
    "manage_items",
    "manage_home",
    "manage_resources",
    "manage_dev"
  ]
};

// Role hierarchy for easy comparison
export const ROLE_RANK = {
  user: 1,
  moderator: 2,
  gm_admin: 3
};

// Universal Permission Check
export function hasPermission(user, permission) {
  if (!user) return false;
  const role = user.roleName;
  return ROLE_PERMISSIONS[role]?.includes(permission) || false;
}