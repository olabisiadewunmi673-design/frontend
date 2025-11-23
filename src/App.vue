<script setup>
import { ref, computed, onMounted } from 'vue'
import Header from './components/Header.vue'
import Alert from './components/Alert.vue'
import SearchBar from './components/SearchBar.vue'
import SortControls from './components/SortControls.vue'
import LessonList from './components/LessonList.vue'
import Cart from './components/Cart.vue'

// API URL from environment or default
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'

// Reactive state
const lessons = ref([])
const cart = ref([])
const showCart = ref(false)
const search = ref('')
const sortBy = ref('')
const sortOrder = ref('asc')
const loading = ref(false)
const error = ref('')
const successMessage = ref('')

// Fetch lessons from API
const fetchLessons = async () => {
  loading.value = true
  error.value = ''
  try {
    const response = await fetch(`${API_URL}/lessons`)
    if (!response.ok) throw new Error('Failed to fetch lessons')
    const data = await response.json()
    lessons.value = data
  } catch (err) {
    error.value = err.message
    console.error('Error fetching lessons:', err)
  } finally {
    loading.value = false
  }
}

// Computed properties
const filteredLessons = computed(() => {
  const term = search.value.toLowerCase()
  return lessons.value.filter(lesson =>
    lesson.subject.toLowerCase().includes(term) ||
    lesson.location.toLowerCase().includes(term) ||
    lesson.price.toString().includes(term) ||
    lesson.spaces.toString().includes(term)
  )
})

const sortedLessons = computed(() => {
  let list = [...filteredLessons.value]
  if (sortBy.value) {
    list.sort((a, b) => {
      let aVal = a[sortBy.value]
      let bVal = b[sortBy.value]
      if (sortOrder.value === 'asc') {
        return aVal > bVal ? 1 : -1
      } else {
        return aVal < bVal ? 1 : -1
      }
    })
  }
  return list
})

const cartItemCount = computed(() => {
  return cart.value.reduce((sum, item) => sum + item.quantity, 0)
})

// Methods
const addToCart = (lesson) => {
  const availableSpaces = getAvailableSpaces(lesson)
  if (availableSpaces <= 0) return
  
  const existingItem = cart.value.find(item => item._id === lesson._id)
  if (existingItem) {
    if (existingItem.quantity < lesson.spaces) {
      existingItem.quantity++
    }
  } else {
    cart.value.push({
      ...lesson,
      quantity: 1
    })
  }
}

const removeFromCart = (item) => {
  if (item.quantity > 1) {
    item.quantity--
  } else {
    const index = cart.value.findIndex(i => i._id === item._id)
    if (index > -1) {
      cart.value.splice(index, 1)
    }
  }
}

const getAvailableSpaces = (lesson) => {
  const cartItem = cart.value.find(item => item._id === lesson._id)
  if (cartItem) {
    return lesson.spaces - cartItem.quantity
  }
  return lesson.spaces
}

const handleCheckout = async (checkoutData) => {
  loading.value = true
  error.value = ''
  successMessage.value = ''
  
  try {
    // Prepare order data
    const lessonIDs = []
    const numSpaces = []
    
    cart.value.forEach(item => {
      for (let i = 0; i < item.quantity; i++) {
        lessonIDs.push(item._id)
        numSpaces.push(1)
      }
    })
    
    // Create order
    const orderResponse = await fetch(`${API_URL}/orders`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        name: checkoutData.name,
        phone: checkoutData.phone,
        lessonIDs,
        numSpaces
      })
    })
    
    if (!orderResponse.ok) throw new Error('Failed to create order')
    
    // Update lesson spaces
    for (const item of cart.value) {
      const lesson = lessons.value.find(l => l._id === item._id)
      if (lesson) {
        const newSpaces = lesson.spaces - item.quantity
        const updateResponse = await fetch(`${API_URL}/lessons/${item._id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            spaces: newSpaces
          })
        })
        
        if (!updateResponse.ok) throw new Error('Failed to update lesson spaces')
        lesson.spaces = newSpaces
      }
    }
    
    // Clear cart and show success
    successMessage.value = `Order confirmed for ${checkoutData.name}! Thank you for your purchase.`
    cart.value = []
    showCart.value = false
    
    // Clear success message after 5 seconds
    setTimeout(() => {
      successMessage.value = ''
    }, 5000)
    
  } catch (err) {
    error.value = err.message
    console.error('Error during checkout:', err)
  } finally {
    loading.value = false
  }
}

// Load lessons on mount
onMounted(() => {
  fetchLessons()
})
</script>

<template>
  <div class="app">
    <!-- Header -->
    <Header 
      :cart-item-count="cartItemCount"
      @toggle-cart="showCart = !showCart"
    />

    <div class="container">
      <!-- Success/Error Messages -->
      <Alert 
        :message="successMessage" 
        type="success" 
        @close="successMessage = ''"
      />
      
      <Alert 
        :message="error" 
        type="danger" 
        @close="error = ''"
      />

      <!-- Loading -->
      <div v-if="loading" class="text-center my-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
      </div>

      <!-- Main Content -->
      <div v-else-if="!showCart">
        <!-- Search and Sort Controls -->
        <div class="row mb-4">
          <div class="col-md-6">
            <SearchBar v-model="search" />
          </div>
          <div class="col-md-6">
            <SortControls 
              v-model:sort-by="sortBy"
              v-model:sort-order="sortOrder"
            />
          </div>
        </div>

        <!-- Lessons Grid -->
        <LessonList 
          :lessons="sortedLessons"
          :cart="cart"
          @add-to-cart="addToCart"
        />
      </div>

      <!-- Cart View -->
      <Cart 
        v-else
        :cart="cart"
        :lessons="lessons"
        :loading="loading"
        @close-cart="showCart = false"
        @add-to-cart="addToCart"
        @remove-from-cart="removeFromCart"
        @checkout="handleCheckout"
      />
    </div>
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
  background-color: #f8f9fa;
}
</style>
