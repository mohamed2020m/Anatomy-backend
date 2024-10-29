import { Student } from "../constants/data"
import { Session } from "../types/next-auth"
import getServerSession from 'next-auth';
import authConfig from '../auth.config';

const API_URL = `${process.env.BACKEND_API}/api/v1`

// Get the session
const getSessionToken = async () => {
    const session = await getServerSession(authConfig);
    const auth : Session = await session.auth();
    
    return auth.user.access_token;
}

const getSessionInfo = async () => {
    const session = await getServerSession(authConfig);
    const auth : Session = await session.auth();

    if (!auth) {
        throw new Error("Session or auth details are not available");
    }

    return {
        token: auth.user.access_token,
        user: {
            id: auth.user.id,
        },
    };
};

// Fetch all students
export const fetchStudents = async (): Promise<Student[]> => {
    const {token, user} = await getSessionInfo();
    // const token = await getSessionToken();
    
    //console.log('jwt token', token);
    //console.log('User ID', user.id);
    
    const headers = {
        Authorization: `Bearer ${token}`, 
       'Content-Type': 'application/json'
    }
    console.log('headers', headers);

    const response = await fetch(`${API_URL}/students/by-professor/${user.id}`, {
    //const response = await fetch(`${API_URL}/students`, {
        method: 'GET',
        headers: headers
    });

    if (!response.ok) {
        throw new Error('Failed to fetch student');
    }

    return await response.json();
};




export const studentService = {
    records: [] as Student[],

    // Initialize with fetched data
    async initialize() {
        this.records = await fetchStudents(); // Fetch student from API
    },

    // Get all student with optional search
    async getAll({ search }: { search?: string }) {
        let students = [...this.records];

        // Search functionality across multiple fields
        if (search) {
            students = students.filter(student =>
                student.firstName.toLowerCase().includes(search.toLowerCase()) ||
                student.lastName.toLowerCase().includes(search.toLowerCase())
            );
        }


        return students;
    },

    // Get paginated results with optional search
    async getStudents({
        page = 1,
        limit = 10,
        search
    }: {
        page?: number;
        limit?: number;
        search?: string;
    }) {
        const allStudents = await this.getAll({ search });
        const totalStudents = allStudents.length;

        // Pagination logic
        const offset = (page - 1) * limit;
        const paginatedStudents = allStudents.slice(offset, offset + limit);

        // Return paginated response
        return {
            success: true,
            total_students: totalStudents,
            offset,
            limit,
            students: paginatedStudents
        };
    }
};

studentService.initialize();