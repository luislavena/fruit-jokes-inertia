<script setup>
import Layout from "@/Layouts/Main.vue";
import { useForm, Link } from "@inertiajs/vue3";
import JokeForm from "./Form.vue";

defineOptions({
    layout: Layout,
});

const props = defineProps({
    joke: {
        type: Object,
        required: true,
    },
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
    setup: props.joke.setup,
    punchline: props.joke.punchline,
    fruit: props.joke.fruit,
    comedian_id: props.joke.comedian_id,
});

const submit = () => {
    form.put(`/jokes/${props.joke.id}`);
};

const deleteJoke = () => {
    if (confirm("Are you sure you want to delete this joke?")) {
        form.delete(`/jokes/${props.joke.id}`);
    }
};
</script>

<template>
    <div class="max-w-7xl mx-auto p-6">
        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900">Edit Joke</h1>
        </div>

        <div class="bg-white rounded-lg shadow p-6">
            <form @submit.prevent="submit">
                <JokeForm
                    :form="form"
                    :comedians="comedians"
                    :fruits="fruits"
                    submit-label="Update Joke"
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
                    <template #extra-actions>
                        <button
                            type="button"
                            @click="deleteJoke"
                            :disabled="form.processing"
                            class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm text-white bg-red-500 hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                            :class="{
                                'opacity-75 cursor-not-allowed':
                                    form.processing,
                            }"
                        >
                            Delete Joke
                        </button>
                    </template>
                </JokeForm>
            </form>
        </div>
    </div>
</template>
