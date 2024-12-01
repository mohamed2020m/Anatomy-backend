import { NavItem } from '@/types';

export type User = {
  id: number;
  name: string;
  company: string;
  role: string;
  verified: boolean;
  status: string;
};

export type Question = {
  questionText: string;
  options: {
    A: string;
    B: string;
    C: string;
    D: string;
  };
  correctAnswer: string;
  explanation: string;
};


export type Category = {
  id: number;
  image: string;
  name: string;
  description: string;
};

export type Quiz = {
  id: number;
  title: string;
  description: string;
};

export type ThreeDObject = {
  id: number;
  image: string;
  name: string;
  description: string;
};

export type Professor = {
  id: number;
  email: string;
  firstName: string;
  lastName: string;
  category: Category;
};


export type Student = {
  id: number;
  email: string;
  firstName: string;
  lastName: string;
  password: string;
  categories: Category[];
};

export type Admin = {
  id: number;
  email: string;
  firstName: string;
  lastName: string;
  password: string;
};


export const navItems: NavItem[] = [
  {
    title: 'Dashboard',
    href: '/admin/dashboard', 
    icon: 'dashboard',
    label: 'Dashboard',
    roles: ['ROLE_ADMIN'],  
  },
  {
    title: 'Categories',
    href: '/admin/categories', 
    icon: 'sendToBack',
    label: 'Category',
    roles: ['ROLE_ADMIN'],  
  },
  {
    title: 'Professors',
    href: '/admin/professors',
    icon: 'user',
    label: 'Professors',
    roles: ['ROLE_ADMIN'], 
  },
  {
    title: 'Dashboard',
    href: '/prof/dashboard', 
    icon: 'dashboard',
    label: 'Dashboard',
    roles: ['ROLE_PROF'],  
  },
  {
    title: 'Categories',
    href: '/prof/categories', 
    icon: 'sendToBack',
    label: 'Category',
    roles: ['ROLE_PROF'],  
  },
  {
    title: 'Assign',
    href: '/prof/assign', 
    icon: 'bookmarkCheck',
    label: 'Assign',
    roles: ['ROLE_PROF'],  
  },
  {
    title: '3D Objects',
    href: '/prof/threedobjects',
    icon: 'rotate3d',
    label: '3D Objects',
    roles: ['ROLE_PROF'],  
  },
  {
    title: 'Quizzes',
    href: '/prof/quiz',
    icon: 'bookCheck',
    label: 'Quizzes',
    roles: ['ROLE_PROF'],  
  },
  {
    title: 'Adminstrators',
    href: '/admin/administrators',
    icon: 'userRoundCog',
    label: 'Adminstrator',
    roles: ['ROLE_ADMIN'], 
  },
  {
    title: 'Students',
    href: '/admin/students',
    icon: 'users',
    label: 'Students',
    roles: ['ROLE_ADMIN'],  
  },
  {
    title: 'Students',
    href: '/prof/students',
    icon: 'user',
    label: 'Students',
    roles: ['ROLE_PROF'],  
  },
  {
    title: 'Profile',
    href: '/prof/profile',
    icon: 'userPen',
    label: 'Profile',
    roles: ['ROLE_PROF'],  
  },
  {
    title: 'Profile',
    href: '/admin/profile',
    icon: 'userPen',
    label: 'Profile',
    roles: ['ROLE_ADMIN'],  
  },
 
  
 
];


export const users: User[] = [
  {
    id: 1,
    name: 'Candice Schiner',
    company: 'Dell',
    role: 'Frontend Developer',
    verified: false,
    status: 'Active'
  },
  {
    id: 2,
    name: 'John Doe',
    company: 'TechCorp',
    role: 'Backend Developer',
    verified: true,
    status: 'Active'
  },
  {
    id: 3,
    name: 'Alice Johnson',
    company: 'WebTech',
    role: 'UI Designer',
    verified: true,
    status: 'Active'
  },
  {
    id: 4,
    name: 'David Smith',
    company: 'Innovate Inc.',
    role: 'Fullstack Developer',
    verified: false,
    status: 'Inactive'
  },
  {
    id: 5,
    name: 'Emma Wilson',
    company: 'TechGuru',
    role: 'Product Manager',
    verified: true,
    status: 'Active'
  },
  {
    id: 6,
    name: 'James Brown',
    company: 'CodeGenius',
    role: 'QA Engineer',
    verified: false,
    status: 'Active'
  },
  {
    id: 7,
    name: 'Laura White',
    company: 'SoftWorks',
    role: 'UX Designer',
    verified: true,
    status: 'Active'
  },
  {
    id: 8,
    name: 'Michael Lee',
    company: 'DevCraft',
    role: 'DevOps Engineer',
    verified: false,
    status: 'Active'
  },
  {
    id: 9,
    name: 'Olivia Green',
    company: 'WebSolutions',
    role: 'Frontend Developer',
    verified: true,
    status: 'Active'
  },
  {
    id: 10,
    name: 'Robert Taylor',
    company: 'DataTech',
    role: 'Data Analyst',
    verified: false,
    status: 'Active'
  }
];

export type Employee = {
  id: number;
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
  gender: string;
  date_of_birth: string; // Consider using a proper date type if possible
  street: string;
  city: string;
  state: string;
  country: string;
  zipcode: string;
  longitude?: number; // Optional field
  latitude?: number; // Optional field
  job: string;
  profile_picture?: string | null; // Profile picture can be a string (URL) or null (if no picture)
};

export type Product = {
  photo_url: string;
  name: string;
  description: string;
  created_at: string;
  price: number;
  id: number;
  category: string;
  updated_at: string;
};
