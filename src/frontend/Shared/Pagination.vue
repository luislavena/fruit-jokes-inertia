<script setup>
import { Link } from "@inertiajs/vue3";

defineProps({
    pagination: {
        type: Object,
        required: true,
    },
    resourceName: {
        type: String,
        required: true,
    },
});
</script>

<template>
    <div class="flex justify-between items-center mt-6">
        <div class="text-sm text-gray-700">
            Showing
            {{ (pagination.current_page - 1) * pagination.per_page + 1 }} to
            {{
                Math.min(
                    pagination.current_page * pagination.per_page,
                    pagination.total,
                )
            }}
            of {{ pagination.total }} {{ resourceName }}
        </div>

        <div class="flex space-x-2">
            <Link
                v-if="pagination.has_previous"
                :href="`?page=${pagination.current_page - 1}`"
                class="px-3 py-1 rounded bg-white border border-gray-300 text-gray-700 hover:bg-gray-50"
            >
                Previous
            </Link>
            <span
                v-else
                class="px-3 py-1 rounded bg-gray-100 border border-gray-300 text-gray-400 cursor-not-allowed"
            >
                Previous
            </span>

            <div class="flex space-x-1">
                <template
                    v-for="pageNum in pagination.total_pages"
                    :key="pageNum"
                >
                    <!-- Current page -->
                    <Link
                        v-if="pageNum === pagination.current_page"
                        :href="`?page=${pageNum}`"
                        class="px-3 py-1 rounded bg-blue-500 text-white"
                    >
                        {{ pageNum }}
                    </Link>

                    <!-- Other pages (limited to prevent too many buttons) -->
                    <Link
                        v-else-if="
                            pageNum <= 2 ||
                            pageNum === pagination.total_pages ||
                            pageNum === pagination.current_page - 1 ||
                            pageNum === pagination.current_page + 1
                        "
                        :href="`?page=${pageNum}`"
                        class="px-3 py-1 rounded bg-white border border-gray-300 text-gray-700 hover:bg-gray-50"
                    >
                        {{ pageNum }}
                    </Link>

                    <!-- Ellipsis for skipped pages -->
                    <span
                        v-else-if="
                            (pageNum === 3 &&
                                pagination.current_page > 4) ||
                            (pageNum === pagination.total_pages - 1 &&
                                pagination.current_page <
                                    pagination.total_pages - 2)
                        "
                        class="px-3 py-1"
                    >
                        ...
                    </span>
                </template>
            </div>

            <Link
                v-if="pagination.has_next"
                :href="`?page=${pagination.current_page + 1}`"
                class="px-3 py-1 rounded bg-white border border-gray-300 text-gray-700 hover:bg-gray-50"
            >
                Next
            </Link>
            <span
                v-else
                class="px-3 py-1 rounded bg-gray-100 border border-gray-300 text-gray-400 cursor-not-allowed"
            >
                Next
            </span>
        </div>
    </div>
</template>