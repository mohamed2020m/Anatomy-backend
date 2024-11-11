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
  fetchSubCategoryCount, 
  fetchObjectsCount, 
  fetchProfessorsByCategories,
  fetchStudentsCount,
  fetchObjectsBySubCategories,
  fetchSubCategoriesByStudents } from '@/services/statitstics';



export default function OverViewPage() {
  const { data: session } = useSession();
  const [categoriesCount, setCategoriesCount] = useState(0);
  const [studentsCount, setStudentsCount] = useState(0);
  const [objectsCounts, setObjectsCounts] = useState(0);
  const [studentsByCategories, setStudentsByCategories] = useState<[string, number][]>([]);
  const [objectsByCategories, setObjectsByCategories] = useState<[string, number][]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;
      setLoading(true);
      try {
        const count = await fetchObjectsCount(session.user.access_token, session.user.id);
        setObjectsCounts(count);
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
        const count = await fetchSubCategoryCount(session.user.access_token, session.user.id);
        setCategoriesCount(count);
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
        const data = await fetchObjectsBySubCategories(session.user.access_token, session.user.id);
        setObjectsByCategories(data);
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
        const count = await fetchStudentsCount(session.user.access_token);
        setStudentsCount(count);
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

  useEffect(() => {
    const fetchData = async () => {
      if (!session) return;

      try {
        const data: [string, number][] = await fetchSubCategoriesByStudents(session.user.access_token, session.user.id);
        // console.log("Data for Bar Chart : ", data);
        
        // if (!Array.isArray(data) || !data.every(item => Array.isArray(item) && item.length === 2)) {
        if (!Array.isArray(data)) {
          throw new Error('Invalid data format');
        }

        setStudentsByCategories(data);
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
              Welcome back, {session.user.name} 👋
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
                      3D Objects Counts
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
                      <div className="text-2xl font-bold">{objectsCounts}</div>
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
                    {loading ? (
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
                    {loading ? (
                      <div className="text-lg">Loading...</div>
                    ) : (
                      <div className="text-2xl font-bold">{studentsCount}</div>
                    )}
                  </CardContent>
                </Card>

                {/* Third Card*/}
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
                    {loading ? (
                      <div className="text-lg">Loading...</div>
                    ) : (
                      <div className="text-2xl font-bold">{studentsCount}</div>
                    )}
                  </CardContent>
                </Card>
                
                {/* <div className="col-span-4 md:col-span-3">
                  <PieGraph apiData={objectsByCategories}/>
                </div>

                <div className="col-span-4 md:col-span-3">
                  <BarGraph data={studentsByCategories}/>
                </div> */}

                 

              </div>

              {/* Chart Section */}
              <div className="flex flex-wrap gap-4 md:flex-nowrap">
                  <div className="flex-1">
                    <PieGraph apiData={objectsByCategories} />
                  </div>
                  <div className="flex-1">
                    <BarGraph data={studentsByCategories} />
                  </div>
              </div>

            </TabsContent>
          </Tabs>
        </div>
      </PageContainer>
    );
  }
}
