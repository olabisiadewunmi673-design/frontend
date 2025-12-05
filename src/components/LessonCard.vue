<template>
  <div class="card h-100 shadow-sm border-0 overflow-hidden">
    <div class="card-img-wrapper">
      <img 
        v-if="lesson.image"
        :src="`${apiUrl}/images/${lesson.image}`" 
        class="card-img-top" 
        :alt="lesson.subject"
      >
      <div v-else class="card-img-top bg-gradient d-flex align-items-center justify-content-center">
        <i :class="iconClass" class="fa-3x text-white opacity-75"></i>
      </div>
      <div class="price-badge">
        £{{ lesson.price }}
      </div>
    </div>
    
    <div class="card-body">
      <div class="d-flex align-items-start mb-3">
        <div class="icon-wrapper me-3">
          <i :class="iconClass" class="fa-2x text-primary"></i>
        </div>
        <div class="flex-grow-1">
          <h5 class="card-title mb-1 fw-bold">{{ lesson.subject }}</h5>
          <p class="card-text text-muted mb-2">
            <i class="fas fa-map-marker-alt me-1"></i> {{ lesson.location }}
          </p>
        </div>
      </div>
      
      <div class="d-flex justify-content-between align-items-center mb-3">
        <div class="spaces-info">
          <i class="fas fa-users me-1 text-success"></i>
          <span class="fw-semibold" :class="availableSpaces <= 2 ? 'text-warning' : 'text-success'">
            {{ availableSpaces }} spaces
          </span>
        </div>
        <div class="availability-badge" :class="getAvailabilityClass()">
          {{ getAvailabilityText() }}
        </div>
      </div>
      
      <button 
        type="button"
        @click="$emit('add-to-cart', lesson)"
        class="btn w-100 py-2 fw-semibold"
        :class="availableSpaces <= 0 ? 'btn-secondary disabled' : 'btn-primary hover-lift'"
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

// Get icon class - use lesson.icon if available, otherwise derive from subject
const iconClass = computed(() => {
  if (props.lesson.icon) return props.lesson.icon
  
  const subject = (props.lesson.subject || '').toLowerCase()
  const iconMap = {
    'math': 'fas fa-calculator',
    'mathematics': 'fas fa-calculator',
    'english': 'fas fa-book',
    'science': 'fas fa-flask',
    'chemistry': 'fas fa-atom',
    'physics': 'fas fa-magnet',
    'biology': 'fas fa-dna',
    'history': 'fas fa-landmark',
    'geography': 'fas fa-globe',
    'music': 'fas fa-music',
    'art': 'fas fa-palette',
    'computer': 'fas fa-laptop-code',
    'french': 'fas fa-language',
    'spanish': 'fas fa-language',
    'economics': 'fas fa-chart-line',
    'health': 'fas fa-heartbeat',
    'gym': 'fas fa-dumbbell',
    'literature': 'fas fa-feather-alt'
  }
  
  for (const [key, icon] of Object.entries(iconMap)) {
    if (subject.includes(key)) return icon
  }
  return 'fas fa-book-open'
})

const getAvailabilityClass = () => {
  if (props.availableSpaces <= 0) return 'bg-danger'
  if (props.availableSpaces <= 2) return 'bg-warning'
  if (props.availableSpaces <= 5) return 'bg-info'
  return 'bg-success'
}

const getAvailabilityText = () => {
  if (props.availableSpaces <= 0) return 'Sold Out'
  if (props.availableSpaces <= 2) return 'Few Left'
  if (props.availableSpaces <= 5) return 'Available'
  return 'Many Spaces'
}
</script>

<style scoped>
.card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border-radius: 12px;
}

.card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
}

.card-img-wrapper {
  position: relative;
  height: 200px;
  overflow: hidden;
}

.card-img-top {
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.card:hover .card-img-top {
  transform: scale(1.05);
}

.bg-gradient {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  height: 200px;
}

.price-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  background: rgba(255, 255, 255, 0.95);
  color: #333;
  padding: 6px 12px;
  border-radius: 20px;
  font-weight: 600;
  font-size: 0.9rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.icon-wrapper {
  width: 48px;
  height: 48px;
  background: rgba(13, 110, 253, 0.1);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.spaces-info {
  display: flex;
  align-items: center;
  gap: 4px;
}

.availability-badge {
  padding: 4px 12px;
  border-radius: 16px;
  font-size: 0.75rem;
  font-weight: 600;
  color: white;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.hover-lift:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3);
}

@media (max-width: 576px) {
  .card {
    margin-bottom: 1rem;
  }
  
  .icon-wrapper {
    width: 40px;
    height: 40px;
  }
  
  .icon-wrapper i {
    font-size: 1.2rem;
  }
}
</style>
