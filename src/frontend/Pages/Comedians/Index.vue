<script setup>
import Layout from "@/Layouts/Main.vue";
import { Link } from "@inertiajs/vue3";
import Pagination from "@/Shared/Pagination.vue";

defineOptions({
    layout: Layout,
});

defineProps({
    comedians: {
        type: Array,
        required: true,
    },
    pagination: {
        type: Object,
        required: true,
    },
});
</script>

<template>
    <div class="max-w-7xl mx-auto p-6">
        <!-- Header -->
        <div class="mb-6 flex justify-between items-center">
            <h1 class="text-2xl font-bold text-gray-900">Comedians</h1>
            <Link
                href="/comedians/new"
                class="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded"
            >
                New Comedian
            </Link>
        </div>

        <!-- Table -->
        <div class="overflow-x-auto bg-white rounded-lg shadow">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Name
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Specialty
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Joke Count
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Created At
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Actions
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    <tr
                        v-for="comedian in comedians"
                        :key="comedian.id"
                        class="hover:bg-gray-50"
                    >
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                        >
                            {{ comedian.name }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ comedian.specialty }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ comedian.joke_count }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ comedian.created_at }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-2"
                        >
                            <Link
                                :href="`/comedians/${comedian.id}/edit`"
                                class="text-blue-500 hover:text-blue-700"
                                >Edit</Link
                            >
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <Pagination :pagination="pagination" resourceName="comedians" />
    </div>
</template>
