<script setup>
import Layout from "@/Layouts/Main.vue";
import { useForm, Link } from "@inertiajs/vue3";
import ComedianForm from "./Form.vue";

defineOptions({
    layout: Layout,
});

const props = defineProps({
    comedian: {
        type: Object,
        required: true,
    },
    errors: {
        type: Object,
        default: () => ({}),
    },
});

const form = useForm({
    name: props.comedian.name,
    specialty: props.comedian.specialty,
});

const submit = () => {
    form.put(`/comedians/${props.comedian.id}`);
};

const deleteComedian = () => {
    if (confirm("Are you sure you want to delete this comedian?")) {
        form.delete(`/comedians/${props.comedian.id}`);
    }
};
</script>

<template>
    <div class="max-w-7xl mx-auto p-6">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Edit Comedian</h1>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <form @submit.prevent="submit">
                <ComedianForm
                    :form="form"
                    submit-label="Update Comedian"
                    :processing="form.processing"
                >
                    <template #cancel-button>
                        <Link
                            href="/comedians"
                            class="px-4 py-2 border border-gray-300 rounded-md text-sm text-gray-700 bg-white hover:bg-gray-50"
                        >
                            Cancel
                        </Link>
                    </template>
                    <template #extra-actions>
                        <button
                            type="button"
                            @click="deleteComedian"
                            :disabled="form.processing"
                            class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm text-white bg-red-500 hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                            :class="{
                                'opacity-75 cursor-not-allowed':
                                    form.processing,
                            }"
                        >
                            Delete Comedian
                        </button>
                    </template>
                </ComedianForm>
            </form>
        </div>
    </div>
</template>
