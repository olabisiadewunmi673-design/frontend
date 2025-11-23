<template>
  <div class="card h-100">
    <img 
      v-if="lesson.image"
      :src="`${apiUrl}/images/${lesson.image}`" 
      class="card-img-top" 
      :alt="lesson.subject"
      style="height: 200px; object-fit: cover;"
    >
    <div v-else class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 200px;">
      <i :class="lesson.icon" class="fa-4x text-muted"></i>
    </div>
    <div class="card-body">
      <h5 class="card-title">
        <i :class="lesson.icon" class="me-2"></i>
        {{ lesson.subject }}
      </h5>
      <p class="card-text">
        <i class="fas fa-map-marker-alt me-1"></i> {{ lesson.location }}<br>
        <i class="fas fa-pound-sign me-1"></i> £{{ lesson.price }}<br>
        <i class="fas fa-users me-1"></i> {{ availableSpaces }} spaces available
      </p>
      <button 
        @click="$emit('add-to-cart', lesson)"
        class="btn btn-primary w-100"
        :disabled="availableSpaces <= 0"
      >
        <i class="fas fa-cart-plus me-2"></i>
        {{ availableSpaces <= 0 ? 'Fully Booked' : 'Add to Cart' }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  lesson: {
    type: Object,
    required: true
  },
  availableSpaces: {
    type: Number,
    required: true
  }
})

const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:3000'

defineEmits(['add-to-cart'])
</script>

<style scoped>
.card {
  transition: transform 0.2s;
}

.card:hover {
  transform: translateY(-5px);
}
</style>
