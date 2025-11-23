<template>
  <div class="input-group">
    <span class="input-group-text"><i class="fas fa-search"></i></span>
    <input 
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      type="text" 
      class="form-control" 
      placeholder="Search lessons..."
    >
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
