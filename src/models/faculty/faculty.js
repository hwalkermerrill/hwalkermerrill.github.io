// Imports
import db from "../db.js";

// Model Functions
/**
 * @param {string|number} identifier - Faculty ID or slug
 * @param {string} identifierType - 'id' or 'slug' (default: 'id')
 * @returns {Promise<Object>} Faculty object with department info, or empty object if not found
 */
const getFaculty = async (identifier, identifierType = "id") => {
  // Build WHERE clause dynamically - search by slug or id
  const whereClause = identifierType === "slug" ? "f.slug = $1" : "f.id = $1";

  const query = `
        SELECT f.id, f.first_name, f.last_name, f.office, f.phone, f.email, 
               f.title, f.gender, f.slug, d.name as department_name, d.code as department_code
        FROM faculty f
        JOIN departments d ON f.department_id = d.id
        WHERE ${whereClause}
    `;

  const result = await db.query(query, [identifier]);

  // Return empty object if faculty member not found
  if (result.rows.length === 0) return {};

  const faculty = result.rows[0];
  return {
    id: faculty.id,
    firstName: faculty.first_name,
    lastName: faculty.last_name,
    name: `${faculty.first_name} ${faculty.last_name}`, // Computed full name
    office: faculty.office,
    phone: faculty.phone,
    email: faculty.email,
    department: faculty.department_name,
    departmentCode: faculty.department_code,
    title: faculty.title,
    gender: faculty.gender,
    slug: faculty.slug
  };
};

/**
 * @param {string} sortBy - Sort option: 'department' (default), 'name', 'title'
 * @returns {Promise<Array>} Array of faculty objects sorted by the specified field
 */
const getSortedFaculty = async (sortBy = "department") => {
  const orderByClause = sortBy === "name" ? "f.last_name, f.first_name" :
    sortBy === "title" ? "f.title, f.last_name" :
      "d.name, f.last_name, f.first_name";

  const query = `
        SELECT f.id, f.first_name, f.last_name, f.office, f.phone, f.email, 
               f.title, f.gender, f.slug, d.name as department_name, d.code as department_code
        FROM faculty f
        JOIN departments d ON f.department_id = d.id
        ORDER BY ${orderByClause}
    `;

  const result = await db.query(query);

  // Transform each row from database format to JavaScript format
  return result.rows.map(faculty => ({
    id: faculty.id,
    firstName: faculty.first_name,
    lastName: faculty.last_name,
    name: `${faculty.first_name} ${faculty.last_name}`,
    office: faculty.office,
    phone: faculty.phone,
    email: faculty.email,
    department: faculty.department_name,
    departmentCode: faculty.department_code,
    title: faculty.title,
    gender: faculty.gender,
    slug: faculty.slug
  }));
};

/**
 * @param {number} departmentId - The ID of the department
 * @param {string} sortBy - Sort option: 'name' (default), 'department', 'title'
 * @returns {Promise<Array>} Array of faculty objects in the specified department
 */
const getFacultyByDepartment = async (departmentId, sortBy = "name") => {
  const orderByClause = sortBy === "name" ? "f.last_name, f.first_name" :
    sortBy === "title" ? "f.title, f.last_name" :
      "d.name, f.last_name, f.first_name";

  const query = `
        SELECT f.id, f.first_name, f.last_name, f.office, f.phone, f.email, 
               f.title, f.gender, f.slug, d.name as department_name, d.code as department_code
        FROM faculty f
        JOIN departments d ON f.department_id = d.id
        WHERE f.department_id = $1
        ORDER BY ${orderByClause}
    `;

  const result = await db.query(query, [departmentId]);

  return result.rows.map(faculty => ({
    id: faculty.id,
    firstName: faculty.first_name,
    lastName: faculty.last_name,
    name: `${faculty.first_name} ${faculty.last_name}`,
    office: faculty.office,
    phone: faculty.phone,
    email: faculty.email,
    department: faculty.department_name,
    departmentCode: faculty.department_code,
    title: faculty.title,
    gender: faculty.gender,
    slug: faculty.slug
  }));
};

// Wrapper Functions
const getFacultyById = (facultyId) => getFaculty(facultyId, "id");
const getFacultyBySlug = (facultySlug) => getFaculty(facultySlug, "slug");

export { getFacultyById, getFacultyBySlug, getSortedFaculty, getFacultyByDepartment };