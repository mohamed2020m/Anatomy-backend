import { NextAuthConfig } from 'next-auth';
import CredentialProvider from 'next-auth/providers/credentials';
import GithubProvider from 'next-auth/providers/github';
import GoogleProvider from 'next-auth/providers/google';

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

      async authorize(credentials, req) {
        // Step 1: Authenticate the user
        const res = await fetch(
          'http://localhost:8080/api/v1/auth/authenticate',
          {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              email: credentials.email,
              password: credentials.password
            })
          }
        );

        // const authData = await res.text();
        // console.log("authData:", authData);

        // const user = {
        //   id: '1',
        //   name: 'Leeuw',
        //   email: credentials?.email as string,
        //   role: 'admin', // Add appropriate role
        //   access_token: 'dummy_access_token',
        //   refresh_token: 'dummy_refresh_token',
        // };

        // return user

        // console.log("Response status:", res.status);

        // Check if the authentication was successful
        if (!res.ok) {
          throw new Error('Invalid login credentials');
        }

        const authData = await res.json();

        // Step 2: Fetch the user details using the user_id from authentication response
        const userRes = await fetch(
          `http://localhost:8080/api/v1/auth/user/${authData.user_id}`,
          {
            headers: {
              Authorization: `Bearer ${authData.access_token}`
            }
          }
        );

        if (!userRes.ok) {
          throw new Error('Failed to fetch user details');
        }

        const user = await userRes.json();

        // eslint-disable-next-line no-console
        console.log('user:', user);

        // Combine user info and token in a format NextAuth expects
        return {
          id: user.id,
          name: user.firstname + ' ' + user.lastname,
          firstname: user.firstname,
          lastname: user.lastname,
          email: user.email,
          role: user.role,
          access_token: authData.access_token,
          refresh_token: authData.refresh_token
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
        token.firstname = user.firstname;
        token.lastname = user.lastname;
        token.email = user.email;
        token.role = user.role;
        token.access_token = user.access_token;
        token.refresh_token = user.refresh_token;
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
