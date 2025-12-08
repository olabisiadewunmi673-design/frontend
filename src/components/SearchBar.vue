<template>
  <div class="search-wrapper">
    <div class="input-group input-group-lg">
      <span class="input-group-text bg-white border-end-0">
        <i class="fas fa-search text-primary"></i>
      </span>
      <input 
        :value="modelValue"
        @input="$emit('update:modelValue', $event.target.value)"
        type="text" 
        class="form-control border-start-0 ps-0" 
        placeholder="Search lessons by subject, location, price or spaces..."
      >
      <button 
        v-if="modelValue"
        @click="$emit('update:modelValue', '')"
        class="btn btn-outline-secondary border-start-0"
        type="button"
      >
        <i class="fas fa-times"></i>
      </button>
    </div>
    <div v-if="modelValue" class="search-results-info mt-2">
      <small class="text-muted">
        <i class="fas fa-info-circle me-1"></i>
        Searching for "{{ modelValue }}"
      </small>
    </div>
  </div>
</template>

<script setup>
defineProps({
  modelValue: {
    type: String,
    required: true
  }
})

defineEmits(['update:modelValue'])
</script>
