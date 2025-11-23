<template>
  <div class="card">
    <div class="card-body">
      <h5 class="card-title">Checkout</h5>
      <form @submit.prevent="$emit('checkout')">
        <div class="mb-3">
          <label for="name" class="form-label">Name (letters only)</label>
          <input 
            :value="name"
            @input="$emit('update:name', $event.target.value)"
            type="text" 
            class="form-control" 
            id="name" 
            pattern="^[A-Za-z\s]+$"
            required
          >
          <div v-if="name && !/^[A-Za-z\s]+$/.test(name)" class="text-danger small mt-1">
            Name must contain only letters and spaces
          </div>
        </div>
        <div class="mb-3">
          <label for="phone" class="form-label">Phone (numbers only)</label>
          <input 
            :value="phone"
            @input="$emit('update:phone', $event.target.value)"
            type="text" 
            class="form-control" 
            id="phone"
            pattern="^[0-9]+$"
            required
          >
          <div v-if="phone && !/^[0-9]+$/.test(phone)" class="text-danger small mt-1">
            Phone must contain only numbers
          </div>
        </div>
        <button 
          type="submit" 
          class="btn btn-success w-100"
          :disabled="!isValid || loading"
        >
          <i class="fas fa-check-circle me-2"></i>
          {{ loading ? 'Processing...' : 'Complete Order' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
defineProps({
  name: {
    type: String,
    required: true
  },
  phone: {
    type: String,
    required: true
  },
  isValid: {
    type: Boolean,
    required: true
  },
  loading: {
    type: Boolean,
    default: false
  }
})

defineEmits(['update:name', 'update:phone', 'checkout'])
</script>
