'use client';

import * as React from 'react';
import { TrendingUp } from 'lucide-react';
import { Label, Pie, PieChart } from 'recharts';

import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle
} from '@/components/ui/card';
import {
  ChartConfig,
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent
} from '@/components/ui/chart';

// Sample API response data
const apiData = [
  ["Main Category", 15],
  ["Subcategory 1", 6],
  ["Subcategory 2", 11]
];


function generateColors(count: number): string[] {
  const predefinedColors = ["#281e18", "#dbab94", "#5c5e63", "#9f8576", "#846856", "#959595", "#bb671c", "#cc9c8c"];
  return predefinedColors.slice(0, count);
}

// Define types
type CategoryData = [string, number];

type PieGraphProps = {
  apiData: CategoryData[];
};


export function PieGraph({  apiData = [] }: PieGraphProps) {

  // Generate dynamic colors for chartData
  const chartData = React.useMemo(() => {
    const colors = generateColors(apiData.length);
    return apiData.map(([category, count], index) => ({
      category,
      count,
      fill: colors[index]
    }));
  }, [apiData]);

  const total = React.useMemo(() => {
    return chartData.reduce((acc, curr) => acc + (curr.count || 0), 0);
  }, [chartData]);

  const chartConfig = {
    total: { label: '3D Objects' },
    ...Object.fromEntries(
      chartData.map((item, index) => [
        item.category,
        { label: item.category, color: item.fill }
      ])
    )
  } satisfies ChartConfig;



  return (
    <Card className="flex flex-col">
      <CardHeader className="items-center pb-0">
      <CardTitle>3D Objects Distribution by Category</CardTitle>
      <CardDescription>3D Objects Statistics</CardDescription>
      </CardHeader>
      <CardContent className="flex-1 pb-0">
        <ChartContainer
          config={chartConfig}
          className="mx-auto aspect-square max-h-[360px]"
        >
          <PieChart>
            <ChartTooltip
              cursor={false}
              content={<ChartTooltipContent hideLabel />}
            />
            <Pie
              data={chartData}
              dataKey="count"
              nameKey="category"
              innerRadius={60}
              strokeWidth={5}
            >
              <Label
                content={({ viewBox }) => {
                  if (viewBox && 'cx' in viewBox && 'cy' in viewBox) {
                    return (
                      <text
                        x={viewBox.cx}
                        y={viewBox.cy}
                        textAnchor="middle"
                        dominantBaseline="middle"
                      >
                        <tspan
                          x={viewBox.cx}
                          y={viewBox.cy}
                          className="fill-foreground text-3xl font-bold"
                        >
                          {total.toLocaleString()}
                        </tspan>
                        <tspan
                          x={viewBox.cx}
                          y={(viewBox.cy || 0) + 24}
                          className="fill-muted-foreground"
                        >
                          3D Objects
                        </tspan>
                      </text>
                    );
                  }
                }}
              />
            </Pie>
          </PieChart>
        </ChartContainer>
      </CardContent>
      <CardFooter className="flex-col gap-2 text-sm">
       {/*  <div className="flex items-center gap-2 font-medium leading-none">
          Trending up by 5.2% this month <TrendingUp className="h-4 w-4" />
        </div> */}
        <div className="leading-none text-muted-foreground">
          Total 3D Objects: {total}
        </div>
      </CardFooter>
    </Card>
  );
}
