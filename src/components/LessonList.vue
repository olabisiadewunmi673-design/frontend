<template>
  <div>
    <!-- Sort Dropdown -->
    <div class="mb-4">
      <div class="dropdown">
        <button 
          class="btn btn-outline-primary dropdown-toggle" 
          type="button" 
          id="sortDropdown" 
          data-bs-toggle="dropdown" 
          aria-expanded="false"
        >
          <i class="fas fa-sort me-2"></i>
          Sort by: {{ getCurrentSortLabel() }}
          <i v-if="sortBy" 
             :class="sortOrder === 'asc' ? 'fas fa-arrow-up ms-2' : 'fas fa-arrow-down ms-2'" 
          ></i>
        </button>
        <ul class="dropdown-menu" aria-labelledby="sortDropdown">
          <li v-for="field in sortFields" :key="field.value">
            <a 
              class="dropdown-item" 
              href="#"
              :class="{ active: sortBy === field.value }"
              @click.prevent="toggleSort(field.value)"
            >
              {{ field.label }}
              <i v-if="sortBy === field.value" 
                 :class="sortOrder === 'asc' ? 'fas fa-arrow-up float-end' : 'fas fa-arrow-down float-end'" 
              ></i>
            </a>
          </li>
          <li v-if="sortBy"><hr class="dropdown-divider"></li>
          <li v-if="sortBy">
            <a 
              class="dropdown-item" 
              href="#"
              @click.prevent="clearSort"
            >
              <i class="fas fa-times me-2"></i>Clear Sort
            </a>
          </li>
        </ul>
      </div>
    </div>
    
    <!-- Lessons Grid -->
    <div class="row g-4">
      <div v-for="lesson in lessons" :key="lesson._id" class="col-sm-6 col-lg-4">
        <LessonCard 
          :lesson="lesson"
          :available-spaces="getAvailableSpaces(lesson)"
          @add-to-cart="$emit('add-to-cart', $event)"
        />
      </div>
    </div>
    
    <!-- Empty State -->
    <div v-if="lessons.length === 0" class="text-center py-5">
      <i class="fas fa-search fa-4x text-muted mb-3"></i>
      <h4 class="text-muted">No lessons found</h4>
      <p class="text-muted">Try adjusting your search or sort criteria</p>
    </div>
  </div>
</template>

<script setup>
import LessonCard from './LessonCard.vue'

const props = defineProps({
  lessons: {
    type: Array,
    required: true
  },
  cart: {
    type: Array,
    required: true
  },
  sortBy: {
    type: String,
    default: ''
  },
  sortOrder: {
    type: String,
    default: 'asc'
  }
})

const emit = defineEmits(['add-to-cart', 'update:sortBy', 'update:sortOrder'])

const sortFields = [
  { value: 'subject', label: 'Subject' },
  { value: 'location', label: 'Location' },
  { value: 'price', label: 'Price' },
  { value: 'spaces', label: 'Spaces' }
]

const getCurrentSortLabel = () => {
  if (!props.sortBy) return 'None'
  const field = sortFields.find(f => f.value === props.sortBy)
  return field ? field.label : 'None'
}

const clearSort = () => {
  emit('update:sortBy', '')
  emit('update:sortOrder', 'asc')
}

const toggleSort = (field) => {
  if (props.sortBy === field) {
    emit('update:sortOrder', props.sortOrder === 'asc' ? 'desc' : 'asc')
  } else {
    emit('update:sortBy', field)
    emit('update:sortOrder', 'asc')
  }
}

const getAvailableSpaces = (lesson) => {
  const cartItem = props.cart.find(item => item._id === lesson._id)
  if (cartItem) {
    return lesson.spaces - cartItem.quantity
  }
  return lesson.spaces
}
</script>
