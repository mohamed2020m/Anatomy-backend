// import { NextAuthConfig } from 'next-auth';
// import CredentialProvider from 'next-auth/providers/credentials';
// import GithubProvider from 'next-auth/providers/github';
// import GoogleProvider from 'next-auth/providers/google';

// const authConfig = {
//   providers: [
//     GithubProvider({
//       clientId: process.env.GITHUB_ID ?? '',
//       clientSecret: process.env.GITHUB_SECRET ?? ''
//     }),
//     GoogleProvider({
//       clientId: process.env.GOOGLE_ID ?? '',
//       clientSecret: process.env.GOOGLE_SECRET ?? ''
//     }),
//     CredentialProvider({
//       credentials: {
//         email: { label: 'Email', type: 'email' },
//         password: { label: 'Password', type: 'password' }
//       },
//       async authorize(credentials, req) {
//         const APP_URL = 'http://localhost:8080/api/v1/auth/login';
//         const res = await fetch(APP_URL, {
//           method: 'POST',
//           headers: { 'Content-Type': 'application/json' },
//           body: JSON.stringify({
//             email: credentials.email,
//             password: credentials.password
//           })
//         });

//         if (!res.ok) {
//           throw new Error('Invalid login credentials');
//         }

//         const authData = await res.json();
//         const userRes = await fetch(`http://localhost:8080/api/v1/me`, {
//           headers: {
//             Authorization: `Bearer ${authData.accessToken}`
//           }
//         });

//         if (!userRes.ok) {
//           throw new Error('Failed to fetch user details');
//         }

//         const user = await userRes.json();

//         return {
//           id: user.id,
//           name: `${user.firstName} ${user.lastName}`,
//           firstname: user.firstName,
//           lastname: user.lastName,
//           email: user.email,
//           role: user.role,
//           access_token: authData.accessToken,
//           refresh_token: authData.refreshToken,
//           expires_in: authData.expiresIn
//         };
//       }
//     })
//   ],
//   session: {
//     strategy: 'jwt'
//   },
//   callbacks: {
//     async jwt({ token, user }) {
//       // When signing in, add user details to the token
//       if (user) {
//         token.id = user.id;
//         token.name = user.name;
//         token.firstname = user.firstname;
//         token.lastname = user.lastname;
//         token.email = user.email;
//         token.role = user.role;
//         token.access_token = user.access_token;
//         token.refresh_token = user.refresh_token;
//         token.exp = Math.floor(Date.now() / 1000) + (user.expires_in / 1000);
//       }

//       console.log('Token:', token.exp);
//       const isTokenExpired = token.exp && Date.now() / 1000 > token.exp; 
//       console.log('Token expired:', isTokenExpired);

//       if (!isTokenExpired) {
//         return token; // Token is still valid, return as is
//       }

//       console.log('Refreshing token...');
//       // console.log('Token:', token.refresh_token);

//       try {
//         const res = await fetch('http://localhost:8080/api/v1/auth/refresh-token', {
//           method: 'POST',
//           headers: {
//             'Content-Type': 'application/json',
//           },
//           body: JSON.stringify({
//             refreshToken: token.refresh_token
//           })
//         });

//         if (!res.ok) throw new Error('Failed to refresh token');

//         const refreshedTokens = await res.json();
//         console.log("token Refreshed");

//         return {
//           ...token,
//           access_token: refreshedTokens.accessToken,
//           refresh_token: refreshedTokens.refreshToken,
//           exp: Date.now() + refreshedTokens.expiresIn * 1000 
//         };
//       } catch (error) {
//         console.error('Failed to refresh token', error);
//         return {
//           ...token,
//           error: 'RefreshAccessTokenError'
//         };
//       }
//     },
//     async session({ session, token }) {
//       if (token.error === 'RefreshAccessTokenError') {
//         // Redirect to login if refresh token fails
//         session.error = 'Your session has expired. Please log in again.';
//         window.location.href = '/';
//         return session;
//       }

//       session.user = {
//         id: token.id as string,
//         name: token.name as string,
//         firstname: token.firstname as string,
//         lastname: token.lastname as string,
//         email: token.email as string,
//         role: token.role as string,
//         access_token: token.access_token as string,
//         refresh_token: token.refresh_token as string,
//         expires_in: token.exp as number,
//         emailVerified: null,
//       };
//       return session;
//     }
//   },
//   pages: {
//     signIn: '/' // Login page
//   }
// } satisfies NextAuthConfig;

// export default authConfig;


// TODO: add the refresh token logic later

import { NextAuthConfig } from 'next-auth';
import CredentialProvider from 'next-auth/providers/credentials';
import GithubProvider from 'next-auth/providers/github';
import GoogleProvider from 'next-auth/providers/google';

const BACKEND_API = process.env.BACKEND_API;

const authConfig = {
  providers: [
    GithubProvider({
      clientId: process.env.GITHUB_ID ?? '',
      clientSecret: process.env.GITHUB_SECRET ?? ''
    }),
    GoogleProvider({
      clientId: process.env.GOOGLE_ID ?? '',
      clientSecret: process.env.GOOGLE_SECRET ?? ''
    }),
    CredentialProvider({
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' }
      },

      async authorize(credentials) {

        const res = await fetch(`${BACKEND_API}/api/v1/auth/login`,
          {
            method: 'POST',
            headers: { 
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            },
            body: JSON.stringify({
              email: credentials?.email,
              password: credentials?.password
            })
          }
        );

        // console.log("Response status:", res.status);

        if (!res.ok) {
          throw new Error('Invalid login credentials');
        }

        const authData = await res.json();


        // Step 2: Fetch user details
        const userRes = await fetch(`${BACKEND_API}/api/v1/me`,
          {
            headers: {
              Authorization: `Bearer ${authData.accessToken}`
            }
          }
        );

        if (!userRes.ok) {
          const errorData = await userRes.json();
          throw new Error(errorData.message || 'Failed to fetch user details');
        }

        const user = await userRes.json();

        // eslint-disable-next-line no-console
        console.log('user:', user);

        // Combine user info and token in a format NextAuth expects
        return {
          id: user.id,
          name: user.firstName + ' ' + user.lastName,
          firstname: user.firstName,
          lastname: user.lastName,
          email: user.email,
          role: user.role,
          access_token: authData.accessToken,
          refresh_token: authData.refreshToken,
          expires_in: authData.expiresIn
        };
      }
    })
  ],
  session: {
    strategy: 'jwt'
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
        token.name = user.name;
        token.firstName = user.firstname;
        token.lastName = user.lastname;
        token.email = user.email;
        token.role = user.role;
        token.access_token = user.access_token;
        token.refresh_token = user.refresh_token;
        token.exp = user.expires_in;
      }
      return token;
    },
    async session({ session, token }) {
      session.user = {
        id: token.id as string,
        name: token.name as string,
        firstname: token.firstname as string,
        lastname: token.lastname as string,
        email: token.email as string,
        role: token.role as string,
        access_token: token.access_token as string,
        refresh_token: token.refresh_token as string,
        expires_in: token.exp as number,
        emailVerified: null // Add emailVerified property
      };
      return session;
    }
  },
  pages: {
    signIn: '/' //sigin page
  }
} satisfies NextAuthConfig;

export default authConfig;
