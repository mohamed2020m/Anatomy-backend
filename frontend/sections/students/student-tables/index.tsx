'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Student } from '@/constants/data';
import { columns } from '../student-tables/columns';
import { useStudentsTableFilters } from './use-student-table-filters';


export default function StudentsTable({
  data,
  totalData
}: {
  data: Student[];
  totalData: number;
}) {
  const {
    categoryFilter,
    setCategoryFilter,
    isAnyFilterActive,
    resetFilters,
    searchQuery,
    setPage,
    setSearchQuery,
    categories
  } = useStudentsTableFilters();

  return (
    <div className="space-y-4 ">
      <div className="flex flex-wrap items-center gap-4">
        <DataTableSearch
          searchKey="name"
          searchQuery={searchQuery}
          setSearchQuery={setSearchQuery}
          setPage={setPage}
        />
        <DataTableFilterBox
          filterKey="category"
          title="Category"
          options={categories.map(cat => ({ value: cat.name, label: cat.name }))}
          setFilterValue={setCategoryFilter}
          filterValue={categoryFilter}
        />
        <DataTableResetFilter
          isFilterActive={isAnyFilterActive}
          onReset={resetFilters}
        />
      </div>
      <DataTable columns={columns} data={data} totalItems={totalData} />
    </div>
  );
}
