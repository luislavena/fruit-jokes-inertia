<script setup>
import Layout from "@/Layouts/Main.vue";
import { useForm, Link } from "@inertiajs/vue3";
import JokeForm from "./Form.vue";

defineOptions({
    layout: Layout,
});

const props = defineProps({
    comedians: {
        type: Array,
        required: true,
    },
    fruits: {
        type: Array,
        required: true,
    },
    errors: {
        type: Object,
        default: () => ({}),
    },
});

const form = useForm({
    setup: "",
    punchline: "",
    fruit: "",
    comedian_id: "",
});

const submit = () => {
    form.post("/jokes");
};
</script>

<template>
    <div class="max-w-7xl mx-auto p-6">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">New Joke</h1>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <form @submit.prevent="submit">
                <JokeForm
                    :form="form"
                    :comedians="comedians"
                    :fruits="fruits"
                    submit-label="Create Joke"
                    :processing="form.processing"
                >
                    <template #cancel-button>
                        <Link
                            href="/jokes"
                            class="px-4 py-2 border border-gray-300 rounded-md text-sm text-gray-700 bg-white hover:bg-gray-50"
                        >
                            Cancel
                        </Link>
                    </template>
                </JokeForm>
            </form>
        </div>
    </div>
</template>
