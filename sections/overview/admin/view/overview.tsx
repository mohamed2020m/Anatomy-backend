'use client';
import { AreaGraph } from '../area-graph';
import { BarGraph } from '../bar-graph';
import { PieGraph } from '../pie-graph';
import { CalendarDateRangePicker } from '@/components/date-range-picker';
import PageContainer from '@/components/layout/page-container';
import { RecentSales } from '../recent-sales';
import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle
} from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { useSession } from 'next-auth/react';
import { useState, useEffect } from 'react';
import { 
  fetchCategoryCount,
  fetchProfessorCount,
  fetchAdministratorsCount,
  fetchStudentsCount,
  fetchProfessorsByCategories } from '@/services/statitstics';



export default function OverViewPage() {
  const { data: session } = useSession();
  const [professorCount, setProfessorCount] = useState(0);
  const [categoriesCount, setCategoriesCount] = useState(0);
  const [administratorsCount, setAdministratorsCount] = useState(0);
  const [studentsCount, setStudentsCount] = useState(0);
  const [professorByCategory, setProfessorByCategory] = useState<[string, number][]>([]);
  const [loading, setLoading] = useState(true);
  const [loadingCat, setLoadingCat] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;
      setLoading(true);
      try {
        const count = await fetchProfessorCount(session.user.access_token);
        setProfessorCount(count);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;
      setLoading(true);
      try {
        const count = await fetchAdministratorsCount(session.user.access_token);
        setAdministratorsCount(count);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;
      setLoadingCat(true);
      try {
        const count = await fetchStudentsCount(session.user.access_token);
        setStudentsCount(count);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoadingCat(false);
      }
    };

    fetchData();
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;
      setLoadingCat(true);
      try {
        const count = await fetchCategoryCount(session.user.access_token);
        setCategoriesCount(count);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoadingCat(false);
      }
    };

    fetchData();
  }, []);
  

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;

      try {
        const data: [string, number][] = await fetchProfessorsByCategories(session.user.access_token);
        // console.log("Data for Pie Chart : ", data);
        
        if (!Array.isArray(data) || !data.every(item => Array.isArray(item) && item.length === 2)) {
          throw new Error('Invalid data format');
        }

        setProfessorByCategory(data);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {

      }
    };

    fetchData();
  }, []);


  if (session) {
    return (
      <PageContainer scrollable>
        <div className="space-y-2">
          <div className="flex items-center justify-between space-y-2">
            <h2 className="text-2xl font-bold tracking-tight">
              Welcome back, {session.user.firstname} 👋
            </h2>
            <div className="hidden items-center space-x-2 md:flex">
              <CalendarDateRangePicker />
              <Button>Download</Button>
            </div>
          </div>
          <Tabs defaultValue="overview" className="space-y-4">
            <TabsList>
              <TabsTrigger value="overview">Overview</TabsTrigger>
              <TabsTrigger value="analytics" disabled>
                Analytics
              </TabsTrigger>
            </TabsList>
            <TabsContent value="overview" className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
                {/* First Card*/}
                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">
                      Professors Counts
                    </CardTitle>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      className="h-4 w-4 text-muted-foreground"
                    >
                      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                      <circle cx="9" cy="7" r="4" />
                      <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
                    </svg>
                  </CardHeader>
                  <CardContent>
                    {loading ? (
                      <div className="text-lg">Loading...</div>
                    ) : (
                      <div className="text-2xl font-bold">{professorCount}</div>
                    )}
                  </CardContent>
                </Card>
                
                {/* Second Card*/}
                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">
                      Categories Counts
                    </CardTitle>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      className="h-4 w-4 text-muted-foreground"
                    >
                      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                      <circle cx="9" cy="7" r="4" />
                      <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
                    </svg>
                  </CardHeader>
                  <CardContent>
                    {loadingCat ? (
                      <div className="text-lg">Loading...</div>
                    ) : (
                      <div className="text-2xl font-bold">{categoriesCount}</div>
                    )}
                  </CardContent>
                </Card>

                {/* Third Card*/}
                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">
                      Admins Counts
                    </CardTitle>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      className="h-4 w-4 text-muted-foreground"
                    >
                      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                      <circle cx="9" cy="7" r="4" />
                      <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
                    </svg>
                  </CardHeader>
                  <CardContent>
                    {loadingCat ? (
                      <div className="text-lg">Loading...</div>
                    ) : (
                      <div className="text-2xl font-bold">{administratorsCount}</div>
                    )}
                  </CardContent>
                </Card>

                {/* Fourth Card*/}
                <Card>
                  <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                    <CardTitle className="text-sm font-medium">
                      Students Counts
                    </CardTitle>
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="none"
                      stroke="currentColor"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth="2"
                      className="h-4 w-4 text-muted-foreground"
                    >
                      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
                      <circle cx="9" cy="7" r="4" />
                      <path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
                    </svg>
                  </CardHeader>
                  <CardContent>
                    {loadingCat ? (
                      <div className="text-lg">Loading...</div>
                    ) : (
                      <div className="text-2xl font-bold">{categoriesCount}</div>
                    )}
                  </CardContent>
                </Card>
                
                
                <div className="col-span-4 md:col-span-3">
                  <PieGraph apiData={professorByCategory}/>
                </div>

              </div>

            </TabsContent>
          </Tabs>
        </div>
      </PageContainer>
    );
  }
}
