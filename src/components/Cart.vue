<template>
  <div class="cart-view">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Shopping Cart</h2>
      <button @click="$emit('close-cart')" class="btn btn-secondary">
        <i class="fas fa-arrow-left me-2"></i>Back to Lessons
      </button>
    </div>

    <div v-if="cart.length === 0" class="alert alert-info">
      Your cart is empty. Add some lessons to get started!
    </div>

    <div v-else>
      <!-- Cart Items -->
      <div class="card mb-4">
        <div class="card-body">
          <div 
            v-for="item in cart" 
            :key="item._id" 
            class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom"
          >
            <div>
              <h6 class="mb-1">{{ item.subject }} - {{ item.location }}</h6>
              <p class="mb-0 text-muted">
                £{{ item.price }} x {{ item.quantity }} = £{{ item.price * item.quantity }}
              </p>
            </div>
            <div class="btn-group">
              <button @click="$emit('remove-from-cart', item)" class="btn btn-sm btn-outline-danger">
                <i class="fas fa-minus"></i>
              </button>
              <span class="btn btn-sm btn-outline-secondary disabled">{{ item.quantity }}</span>
              <button 
                @click="$emit('add-to-cart', item)" 
                :disabled="getAvailableSpaces(item) <= 0"
                class="btn btn-sm btn-outline-success"
              >
                <i class="fas fa-plus"></i>
              </button>
            </div>
          </div>
          <div class="text-end">
            <h5>Total: £{{ cartTotal }}</h5>
          </div>
        </div>
      </div>

      <!-- Checkout Form -->
      <Checkout
        v-model:name="checkoutName"
        v-model:phone="checkoutPhone"
        :is-valid="isValidCheckout"
        :loading="loading"
        @checkout="handleCheckout"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import Checkout from './Checkout.vue'

const props = defineProps({
  cart: {
    type: Array,
    required: true
  },
  lessons: {
    type: Array,
    required: true
  },
  loading: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['close-cart', 'add-to-cart', 'remove-from-cart', 'checkout'])

const checkoutName = ref('')
const checkoutPhone = ref('')

const cartTotal = computed(() => {
  return props.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0)
})

const isValidCheckout = computed(() => {
  const nameValid = /^[A-Za-z\s]+$/.test(checkoutName.value)
  const phoneValid = /^[0-9]+$/.test(checkoutPhone.value)
  return nameValid && phoneValid && props.cart.length > 0
})

const getAvailableSpaces = (lesson) => {
  const fullLesson = props.lessons.find(l => l._id === lesson._id)
  if (fullLesson) {
    return fullLesson.spaces - lesson.quantity
  }
  return 0
}

const handleCheckout = () => {
  emit('checkout', {
    name: checkoutName.value,
    phone: checkoutPhone.value
  })
  // Clear form after checkout
  checkoutName.value = ''
  checkoutPhone.value = ''
}
</script>

<style scoped>
.cart-view {
  max-width: 800px;
  margin: 0 auto;
}
</style>
