<script setup>
import Layout from "@/Layouts/Main.vue";
import { useForm, Link } from "@inertiajs/vue3";
import ComedianForm from "./Form.vue";

defineOptions({
    layout: Layout,
});

const form = useForm({
    name: "",
    specialty: "",
});

const submit = () => {
    form.post("/comedians");
};
</script>

<template>
    <div class="max-w-7xl mx-auto p-6">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">New Comedian</h1>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <form @submit.prevent="submit">
                <ComedianForm
                    :form="form"
                    submit-label="Create Comedian"
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
                </ComedianForm>
            </form>
        </div>
    </div>
</template>
