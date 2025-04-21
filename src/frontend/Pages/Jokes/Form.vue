<script setup>
const props = defineProps({
    form: {
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
    submitLabel: {
        type: String,
        default: "Save",
    },
    processing: {
        type: Boolean,
        default: false,
    },
});
</script>

<template>
    <div>
        <div class="mb-4">
            <label
                for="setup"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Setup</label
            >
            <input
                id="setup"
                type="text"
                v-model="form.setup"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                :class="{
                    'border-red-500 focus:ring-red-500 focus:border-red-500':
                        form.errors.setup,
                }"
            />
            <p v-if="form.errors.setup" class="mt-1 text-sm text-red-600">
                {{ form.errors.setup }}
            </p>
        </div>

        <div class="mb-4">
            <label
                for="punchline"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Punchline</label
            >
            <input
                id="punchline"
                type="text"
                v-model="form.punchline"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                :class="{
                    'border-red-500 focus:ring-red-500 focus:border-red-500':
                        form.errors.punchline,
                }"
            />
            <p v-if="form.errors.punchline" class="mt-1 text-sm text-red-600">
                {{ form.errors.punchline }}
            </p>
        </div>

        <div class="mb-4">
            <label
                for="fruit"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Fruit</label
            >
            <select
                id="fruit"
                v-model="form.fruit"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                :class="{
                    'border-red-500 focus:ring-red-500 focus:border-red-500':
                        form.errors.fruit,
                }"
            >
                <option value="" disabled>Select a fruit</option>
                <option
                    v-for="fruit in fruits"
                    :key="fruit"
                    :value="fruit"
                >
                    {{ fruit }}
                </option>
            </select>
            <p v-if="form.errors.fruit" class="mt-1 text-sm text-red-600">
                {{ form.errors.fruit }}
            </p>
        </div>

        <div class="mb-6">
            <label
                for="comedian_id"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Comedian</label
            >
            <select
                id="comedian_id"
                v-model="form.comedian_id"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                :class="{
                    'border-red-500 focus:ring-red-500 focus:border-red-500':
                        form.errors.comedian_id,
                }"
            >
                <option value="" disabled>Select a comedian</option>
                <option
                    v-for="comedian in comedians"
                    :key="comedian.id"
                    :value="comedian.id"
                >
                    {{ comedian.name }}
                </option>
            </select>
            <p v-if="form.errors.comedian_id" class="mt-1 text-sm text-red-600">
                {{ form.errors.comedian_id }}
            </p>
        </div>

        <div class="flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <slot name="cancel-button"></slot>
                <button
                    type="submit"
                    :disabled="processing"
                    class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm text-white bg-blue-500 hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                    :class="{
                        'opacity-75 cursor-not-allowed': processing,
                    }"
                >
                    {{ submitLabel }}
                </button>
            </div>
            <slot name="extra-actions"></slot>
        </div>
    </div>
</template>