<template>
  <header class="bg-primary text-white py-3 mb-4">
    <div class="container">
      <div class="d-flex justify-content-between align-items-center">
        <h1 class="h3 mb-0">
          <i class="fas fa-graduation-cap me-2"></i>
          CST3144 Lesson Store
        </h1>
        <button 
          @click="$emit('toggle-cart')"
          class="btn btn-light position-relative"
          :disabled="cartItemCount === 0"
        >
          <i class="fas fa-shopping-cart"></i>
          Cart
          <span v-if="cartItemCount > 0" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
            {{ cartItemCount }}
          </span>
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
defineProps({
  cartItemCount: {
    type: Number,
    default: 0
  }
})

defineEmits(['toggle-cart'])
</script>
