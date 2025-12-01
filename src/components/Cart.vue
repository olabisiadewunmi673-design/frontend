<template>
  <div class="cart-view">
    <!-- Cart Header -->
    <div class="cart-header">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h2 class="cart-title">
            <i class="fas fa-shopping-cart me-3"></i>Your Cart
          </h2>
          <p class="cart-subtitle" v-if="cart.length > 0">
            {{ cart.length }} item{{ cart.length > 1 ? 's' : '' }} in your cart
          </p>
        </div>
        <button type="button" @click="$emit('close-cart')" class="btn back-btn">
          <i class="fas fa-arrow-left me-2"></i>Back to Lessons
        </button>
      </div>
    </div>

    <!-- Empty Cart State -->
    <div v-if="cart.length === 0" class="empty-cart">
      <div class="empty-cart-icon">
        <i class="fas fa-shopping-basket"></i>
      </div>
      <h4>Your cart is empty</h4>
      <p>Start adding some amazing lessons to your cart!</p>
      <button type="button" @click="$emit('close-cart')" class="btn btn-primary">
        <i class="fas fa-book-open me-2"></i>Browse Lessons
      </button>
    </div>

    <div v-else class="cart-content">
      <!-- Cart Items -->
      <div class="cart-items-card">
        <div class="card-header-custom">
          <i class="fas fa-list me-2"></i>Order Summary
        </div>
        <div class="cart-items-body">
          <div 
            v-for="(item, index) in cart" 
            :key="item._id" 
            class="cart-item"
            :style="{ animationDelay: `${index * 0.1}s` }"
          >
            <div class="item-icon">
              <i :class="item.icon" class="fa-lg"></i>
            </div>
            <div class="item-details">
              <h6 class="item-title">{{ item.subject }}</h6>
              <p class="item-location">
                <i class="fas fa-map-marker-alt me-1"></i>{{ item.location }}
              </p>
            </div>
            <div class="item-price">
              £{{ item.price }} × {{ item.quantity }}
            </div>
            <div class="quantity-controls">
              <button type="button" @click="$emit('remove-from-cart', item)" class="qty-btn minus">
                <i class="fas fa-minus"></i>
              </button>
              <span class="qty-display">{{ item.quantity }}</span>
              <button 
                type="button"
                @click="$emit('add-to-cart', item)" 
                :disabled="getAvailableSpaces(item) <= 0"
                class="qty-btn plus"
              >
                <i class="fas fa-plus"></i>
              </button>
            </div>
            <div class="item-total">
              £{{ item.price * item.quantity }}
            </div>
          </div>
        </div>
        
        <!-- Cart Total -->
        <div class="cart-total">
          <div class="total-row">
            <span>Subtotal</span>
            <span>£{{ cartTotal }}</span>
          </div>
          <div class="total-row total-final">
            <span>Total</span>
            <span class="total-amount">£{{ cartTotal }}</span>
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
  max-width: 900px;
  margin: 0 auto;
}

.cart-header {
  margin-bottom: 2rem;
}

.cart-title {
  font-size: 2rem;
  font-weight: 800;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.25rem;
}

.cart-subtitle {
  color: #64748b;
  margin-bottom: 0;
}

.back-btn {
  background: white;
  color: #667eea;
  border: 2px solid #667eea;
  font-weight: 600;
  padding: 0.75rem 1.5rem;
  border-radius: 50px;
  transition: all 0.3s ease;
}

.back-btn:hover {
  background: #667eea;
  color: white;
  transform: translateX(-4px);
}

.empty-cart {
  text-align: center;
  padding: 4rem 2rem;
  background: white;
  border-radius: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.empty-cart-icon {
  width: 100px;
  height: 100px;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1.5rem;
  font-size: 2.5rem;
  color: #667eea;
}

.empty-cart h4 {
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.empty-cart p {
  color: #64748b;
  margin-bottom: 1.5rem;
}

.cart-content {
  display: grid;
  gap: 2rem;
}

.cart-items-card {
  background: white;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.card-header-custom {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 1rem 1.5rem;
  font-weight: 600;
  font-size: 1rem;
}

.cart-items-body {
  padding: 1rem;
}

.cart-item {
  display: grid;
  grid-template-columns: 50px 1fr auto auto auto;
  gap: 1rem;
  align-items: center;
  padding: 1rem;
  border-radius: 12px;
  background: #f8fafc;
  margin-bottom: 0.75rem;
  animation: slideIn 0.4s ease-out forwards;
  opacity: 0;
}

@keyframes slideIn {
  from { opacity: 0; transform: translateX(-20px); }
  to { opacity: 1; transform: translateX(0); }
}

.item-icon {
  width: 50px;
  height: 50px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

.item-details {
  min-width: 0;
}

.item-title {
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 0.25rem;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.item-location {
  font-size: 0.875rem;
  color: #64748b;
  margin-bottom: 0;
}

.item-price {
  color: #64748b;
  font-size: 0.875rem;
  white-space: nowrap;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.qty-btn {
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.75rem;
}

.qty-btn.minus {
  background: #fee2e2;
  color: #ef4444;
}

.qty-btn.minus:hover {
  background: #ef4444;
  color: white;
}

.qty-btn.plus {
  background: #d1fae5;
  color: #10b981;
}

.qty-btn.plus:hover:not(:disabled) {
  background: #10b981;
  color: white;
}

.qty-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.qty-display {
  font-weight: 700;
  min-width: 24px;
  text-align: center;
}

.item-total {
  font-weight: 700;
  color: #1e293b;
  font-size: 1rem;
}

.cart-total {
  padding: 1.5rem;
  border-top: 2px dashed #e2e8f0;
}

.total-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
  color: #64748b;
}

.total-final {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 2px solid #e2e8f0;
  font-size: 1.25rem;
  color: #1e293b;
  margin-bottom: 0;
}

.total-amount {
  font-weight: 800;
  font-size: 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

@media (max-width: 768px) {
  .cart-item {
    grid-template-columns: 40px 1fr;
    gap: 0.75rem;
  }
  
  .item-price {
    grid-column: 2;
  }
  
  .quantity-controls {
    grid-column: 2;
  }
  
  .item-total {
    grid-column: 2;
    text-align: right;
  }
  
  .cart-title {
    font-size: 1.5rem;
  }
  
  .back-btn {
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
  }
}
</style>
