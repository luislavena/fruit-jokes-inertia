<script setup>
import { Disclosure, DisclosureButton, DisclosurePanel } from "@headlessui/vue";
import { Bars3Icon, XMarkIcon } from "@heroicons/vue/24/outline";
import { Link } from "@inertiajs/vue3";
import emojiHappy from "../assets/emoji-happy.svg";

const mainNavigation = [
    { name: "Dashboard", href: "/", component: "Dashboard" },
    { name: "Comedians", href: "/comedians", component: "Comedians/Index" },
    { name: "Jokes", href: "/jokes", component: "Jokes/Index" },
];
</script>

<template>
    <div class="min-h-full">
        <Disclosure
            as="nav"
            class="border-b border-blue-200 bg-white"
            v-slot="{ open }"
        >
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="flex h-16 items-center justify-between">
                    <div class="flex items-center">
                        <div class="shrink-0">
                            <img
                                class="size-8"
                                :src="emojiHappy"
                                alt="Fruit Jokes"
                            />
                        </div>
                        <div class="hidden md:block">
                            <div class="ml-10 flex items-baseline space-x-4">
                                <Link
                                    v-for="item in mainNavigation"
                                    :key="item.name"
                                    :href="item.href"
                                    :class="[
                                        $page.component === item.component
                                            ? 'bg-blue-900 text-white'
                                            : 'text-blue-600 hover:bg-blue-400 hover:text-white',
                                        'rounded-md px-3 py-2 text-sm font-medium',
                                    ]"
                                    :aria-current="
                                        $page.component === item.component
                                            ? 'page'
                                            : undefined
                                    "
                                    >{{ item.name }}</Link
                                >
                            </div>
                        </div>
                    </div>
                    <div class="-mr-2 flex md:hidden">
                        <!-- Mobile menu button -->
                        <DisclosureButton
                            class="relative inline-flex items-center justify-center rounded-md bg-white p-2 text-blue-400 hover:bg-blue-100 hover:text-blue-500 focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 focus:outline-hidden"
                        >
                            <span class="absolute -inset-0.5" />
                            <span class="sr-only">Open main menu</span>
                            <Bars3Icon
                                v-if="!open"
                                class="block size-6"
                                aria-hidden="true"
                            />
                            <XMarkIcon
                                v-else
                                class="block size-6"
                                aria-hidden="true"
                            />
                        </DisclosureButton>
                    </div>
                </div>
            </div>

            <DisclosurePanel class="md:hidden">
                <div class="space-y-1 px-2 pt-2 pb-3 sm:px-3">
                    <Link
                        v-for="item in mainNavigation"
                        :key="item.name"
                        :href="item.href"
                        :class="[
                            $page.component === item.component
                                ? 'bg-blue-900 text-white'
                                : 'text-blue-600 hover:bg-blue-400 hover:text-white',
                            'block rounded-md px-3 py-2 text-base font-medium',
                        ]"
                        :aria-current="
                            $page.component === item.component
                                ? 'page'
                                : undefined
                        "
                        >{{ item.name }}</Link
                    >
                </div>
            </DisclosurePanel>
        </Disclosure>

        <main>
            <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
                <slot />
            </div>
        </main>
    </div>
</template>
