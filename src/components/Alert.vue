<template>
  <div 
    v-if="message"
    :class="`alert alert-${type} alert-dismissible fade show`" 
    role="alert"
  >
    {{ message }}
    <button 
      type="button" 
      class="btn-close" 
      @click="$emit('close')"
      aria-label="Close"
    ></button>
  </div>
</template>

<script setup>
defineProps({
  message: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'info',
    validator: (value) => ['success', 'danger', 'warning', 'info'].includes(value)
  }
})

defineEmits(['close'])
</script>
