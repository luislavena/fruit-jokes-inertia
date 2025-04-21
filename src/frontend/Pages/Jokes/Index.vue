<script setup>
import Layout from "@/Layouts/Main.vue";
import { Link } from "@inertiajs/vue3";
import Pagination from "@/Shared/Pagination.vue";

defineOptions({
    layout: Layout,
});

defineProps({
    jokes: {
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
            <h1 class="text-2xl font-bold text-gray-900">Jokes</h1>
            <Link
                href="/jokes/new"
                class="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded"
            >
                New Joke
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
                            Setup
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Punchline
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Fruit
                        </th>
                        <th
                            class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                        >
                            Comedian
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
                        v-for="joke in jokes"
                        :key="joke.id"
                        class="hover:bg-gray-50"
                    >
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"
                        >
                            {{ joke.setup }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ joke.punchline }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ joke.fruit }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ joke.comedian_name }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"
                        >
                            {{ joke.created_at }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-2"
                        >
                            <Link
                                :href="`/jokes/${joke.id}/edit`"
                                class="text-blue-500 hover:text-blue-700"
                                >Edit</Link
                            >
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <Pagination :pagination="pagination" resourceName="jokes" />
    </div>
</template>
