'use client';

import { DataTable } from '@/components/ui/table/data-table';
import { DataTableFilterBox } from '@/components/ui/table/data-table-filter-box';
import { DataTableResetFilter } from '@/components/ui/table/data-table-reset-filter';
import { DataTableSearch } from '@/components/ui/table/data-table-search';
import { Professor } from '@/constants/data';
import { columns } from '../professor-tables/columns';
import {  useProfessorsTableFilters } from './use-professor-table-filters';

export default function ProfessorssTable({
  data,
  totalData
}: {
  data: Professor[];
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
  } = useProfessorsTableFilters();

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
