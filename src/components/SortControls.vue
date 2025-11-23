<template>
  <div class="btn-group" role="group">
    <button 
      v-for="field in sortFields"
      :key="field.value"
      @click="toggleSort(field.value)"
      class="btn btn-outline-primary"
      :class="{ active: sortBy === field.value }"
    >
      {{ field.label }}
      <i v-if="sortBy === field.value" 
         :class="sortOrder === 'asc' ? 'fas fa-arrow-up' : 'fas fa-arrow-down'" 
         class="ms-1"></i>
    </button>
  </div>
</template>

<script setup>
const props = defineProps({
  sortBy: {
    type: String,
    default: ''
  },
  sortOrder: {
    type: String,
    default: 'asc'
  }
})

const emit = defineEmits(['update:sortBy', 'update:sortOrder'])

const sortFields = [
  { value: 'subject', label: 'Subject' },
  { value: 'location', label: 'Location' },
  { value: 'price', label: 'Price' },
  { value: 'spaces', label: 'Spaces' }
]

const toggleSort = (field) => {
  if (props.sortBy === field) {
    emit('update:sortOrder', props.sortOrder === 'asc' ? 'desc' : 'asc')
  } else {
    emit('update:sortBy', field)
    emit('update:sortOrder', 'asc')
  }
}
</script>
