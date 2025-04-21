<script setup>
const props = defineProps({
    form: {
        type: Object,
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
                for="name"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Name</label
            >
            <input
                id="name"
                type="text"
                v-model="form.name"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                :class="{
                    'border-red-500 focus:ring-red-500 focus:border-red-500':
                        form.errors.name,
                }"
            />
            <p v-if="form.errors.name" class="mt-1 text-sm text-red-600">
                {{ form.errors.name }}
            </p>
        </div>

        <div class="mb-6">
            <label
                for="specialty"
                class="block text-sm font-medium text-gray-700 mb-1"
                >Specialty</label
            >
            <input
                id="specialty"
                type="text"
                v-model="form.specialty"
                class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                :class="{
                    'border-red-500 focus:ring-red-500 focus:border-red-500':
                        form.errors.specialty,
                }"
            />
            <p v-if="form.errors.specialty" class="mt-1 text-sm text-red-600">
                {{ form.errors.specialty }}
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
