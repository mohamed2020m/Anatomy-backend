import { Student } from "../constants/data"
import { Session } from "../types/next-auth"
import getServerSession from 'next-auth';
import authConfig from '../auth.config';

const API_URL = `${process.env.BACKEND_API}/api/v1`


// Get session info
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
            role: auth.user.role,
        },
    };
};

// Base API call function
const apiCall = async (endpoint: string, options: RequestInit = {}) => {
    const { token } = await getSessionInfo();
    
    const headers = {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        ...options.headers,
    };

    const response = await fetch(`${API_URL}${endpoint}`, {
        ...options,
        headers,
    });

    if (!response.ok) {
        throw new Error(`API call failed: ${response.statusText}`);
    }

    return response.json();
};


export const studentService = {
    records: [] as Student[],

    // Initialize with fetched data based on user role
    async initialize() {
        const { user } = await getSessionInfo();
        
        // Different endpoints based on role
        const endpoint = user.role === 'ROLE_ADMIN' 
            ? '/students'
            : `/students/by-professor/${user.id}`;
            
        this.records = await apiCall(endpoint);
    },

    // Get all students with filtering options
    async getAll(options: {
        search?: string;
        professorId?: string;
        courseId?: string;
        status?: string;
    } = {}) {
        let students = [...this.records];

        // Apply filters
        if (options.search) {
            students = students.filter(student =>
                student.firstName.toLowerCase().includes(options.search!.toLowerCase()) ||
                student.lastName.toLowerCase().includes(options.search!.toLowerCase())
            );
        }

        return students;
    },

    // Get paginated results with filtering options
    async getStudents({
        page = 1,
        limit = 10,
        ...filterOptions
    }: {
        page?: number;
        limit?: number;
        search?: string;
        professorId?: string;
        courseId?: string;
        status?: string;
    }) {
        const allStudents = await this.getAll(filterOptions);
        const totalStudents = allStudents.length;

        const offset = (page - 1) * limit;
        const paginatedStudents = allStudents.slice(offset, offset + limit);

        return {
            success: true,
            total_students: totalStudents,
            offset,
            limit,
            students: paginatedStudents
        };
    },

    // Refresh data
    async refresh() {
        await this.initialize();
    },

    // Get a single student by ID
    async getStudentById(id: string) {
        const { token } = await getSessionInfo();
        return apiCall(`/students/${id}`);
    },

    // Update a student
    async updateStudent(id: string, data: Partial<Student>) {
        const response = await apiCall(`/students/${id}`, {
            method: 'PUT',
            body: JSON.stringify(data),
        });
        await this.refresh();
        return response;
    },

    // Create a new student
    async createStudent(data: Omit<Student, 'id'>) {
        const response = await apiCall('/students', {
            method: 'POST',
            body: JSON.stringify(data),
        });
        await this.refresh();
        return response;
    }
};