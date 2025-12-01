<script setup>
import { ref, computed, onMounted } from 'vue'
import Header from './components/Header.vue'
import Alert from './components/Alert.vue'
import SearchBar from './components/SearchBar.vue'
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

const uniqueLocations = computed(() => {
  const locations = new Set(lessons.value.map(l => l.location))
  return locations.size
})

const totalSpaces = computed(() => {
  return lessons.value.reduce((sum, l) => sum + l.spaces, 0)
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

    <!-- Hero Section -->
    <section v-if="!showCart && !loading" class="hero-section">
      <div class="container">
        <div class="hero-content">
          <h2 class="hero-title">Find Your Perfect Lesson</h2>
          <p class="hero-subtitle">Discover a wide range of educational courses tailored to your needs</p>
          <div class="hero-stats">
            <div class="stat-box">
              <i class="fas fa-book text-primary"></i>
              <span class="stat-number">{{ lessons.length }}</span>
              <span class="stat-label">Courses</span>
            </div>
            <div class="stat-box">
              <i class="fas fa-map-marker-alt text-danger"></i>
              <span class="stat-number">{{ uniqueLocations }}</span>
              <span class="stat-label">Locations</span>
            </div>
            <div class="stat-box">
              <i class="fas fa-users text-success"></i>
              <span class="stat-number">{{ totalSpaces }}</span>
              <span class="stat-label">Available Spaces</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <main class="main-content">
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
        <div v-if="loading" class="loading-container">
          <div class="loading-spinner">
            <div class="spinner-ring"></div>
            <div class="spinner-ring"></div>
            <div class="spinner-ring"></div>
          </div>
          <p class="loading-text">Loading amazing lessons...</p>
        </div>

        <!-- Main Content -->
        <div v-else-if="!showCart" class="animate-fade-in">
          <!-- Search Bar -->
          <div class="mb-4">
            <SearchBar v-model="search" />
          </div>

          <!-- Lessons Grid with Sort -->
          <LessonList 
            :lessons="sortedLessons"
            :cart="cart"
            :sort-by="sortBy"
            :sort-order="sortOrder"
            @add-to-cart="addToCart"
            @update:sort-by="sortBy = $event"
            @update:sort-order="sortOrder = $event"
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
          class="animate-fade-in"
        />
      </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
      <div class="container">
        <p>&copy; 2024 Lesson Store - CST3144 Coursework</p>
      </div>
    </footer>
  </div>
</template>

<style scoped>
.app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, #f8fafc 0%, #e2e8f0 100%);
}

.hero-section {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
  padding: 3rem 0;
  border-bottom: 1px solid rgba(102, 126, 234, 0.1);
}

.hero-content {
  text-align: center;
}

.hero-title {
  font-size: 2.5rem;
  font-weight: 800;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 0.5rem;
}

.hero-subtitle {
  color: #64748b;
  font-size: 1.125rem;
  margin-bottom: 2rem;
}

.hero-stats {
  display: flex;
  justify-content: center;
  gap: 2rem;
  flex-wrap: wrap;
}

.stat-box {
  background: white;
  padding: 1.5rem 2rem;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  min-width: 120px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-box:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
}

.stat-box i {
  font-size: 1.5rem;
}

.stat-number {
  font-size: 2rem;
  font-weight: 800;
  color: #1e293b;
}

.stat-label {
  font-size: 0.875rem;
  color: #64748b;
  font-weight: 500;
}

.main-content {
  flex: 1;
  padding: 2rem 0;
}

.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 0;
}

.loading-spinner {
  position: relative;
  width: 80px;
  height: 80px;
}

.spinner-ring {
  position: absolute;
  width: 100%;
  height: 100%;
  border: 4px solid transparent;
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
}

.spinner-ring:nth-child(1) {
  animation-delay: -0.45s;
}

.spinner-ring:nth-child(2) {
  animation-delay: -0.3s;
  width: 70%;
  height: 70%;
  top: 15%;
  left: 15%;
  border-top-color: #764ba2;
}

.spinner-ring:nth-child(3) {
  animation-delay: -0.15s;
  width: 40%;
  height: 40%;
  top: 30%;
  left: 30%;
  border-top-color: #f093fb;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.loading-text {
  margin-top: 1.5rem;
  color: #64748b;
  font-weight: 500;
}

.footer {
  background: #1e293b;
  color: rgba(255, 255, 255, 0.7);
  padding: 1.5rem 0;
  text-align: center;
  margin-top: auto;
}

.footer p {
  margin: 0;
  font-size: 0.875rem;
}

@media (max-width: 768px) {
  .hero-title {
    font-size: 1.75rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .hero-stats {
    gap: 1rem;
  }
  
  .stat-box {
    padding: 1rem 1.5rem;
    min-width: 100px;
  }
  
  .stat-number {
    font-size: 1.5rem;
  }
}
</style>
