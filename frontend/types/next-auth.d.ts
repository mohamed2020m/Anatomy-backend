import NextAuth, { DefaultSession } from 'next-auth';

declare module 'next-auth' {
  // type UserSession = DefaultSession['user'];

  // Extend the User interface to include the token
  interface User extends DefaultUser {
    id: number;
    name: string,
    firstname: string,
    lastname: string,
    email: string;
    role: string;
    access_token: string;
    refresh_token: string;
    expires_in: number;
  }

  // type UserSession = DefaultSession['user'] & {
  //   jwt: string;
  // };


  // interface Session {
  //   user: UserSession;
  // }

  // interface Session extends DefaultSession {
  //   user: User; // Ensure the user is typed
  //   jwt: string; // Add JWT to the Session interface
  // }

  interface Session extends DefaultSession {
    user: User; // The user object now includes the extended User type
    expires_in?: string; // Optional if you're storing it
    error?: string;      // Optional field for handling errors
  }

  interface CredentialsInputs {
    email: string;
    password: string;
  }
}


// import NextAuth, { DefaultSession } from 'next-auth';

// declare module 'next-auth' {
//   type UserSession = DefaultSession['user'];
//   interface Session {
//     user: UserSession;
//   }

//   interface CredentialsInputs {
//     email: string;
//     password: string;
//   }
// }