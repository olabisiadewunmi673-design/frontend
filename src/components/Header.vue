<template>
  <header class="header-main">
    <div class="container-fluid px-4">
      <nav class="navbar navbar-expand-lg">
        <div class="container-fluid">
          <a href="#" class="navbar-brand d-flex align-items-center">
            <div class="logo-icon me-3">
              <i class="fas fa-graduation-cap"></i>
            </div>
            <div>
              <h1 class="brand-title mb-0">Lesson Store</h1>
              <small class="brand-subtitle">CST3144 Coursework</small>
            </div>
          </a>
          
          <button 
            class="navbar-toggler border-0"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarNav"
            aria-controls="navbarNav"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <i class="fas fa-bars text-white fs-4"></i>
          </button>
          
          <div class="collapse navbar-collapse" id="navbarNav">
            <div class="ms-auto d-flex align-items-center gap-3">
              <div class="nav-stats d-none d-md-flex">
                <div class="stat-item">
                  <i class="fas fa-book-open me-1"></i>
                  <span>Browse Lessons</span>
                </div>
              </div>
              <button 
                type="button"
                @click="$emit('toggle-cart')"
                class="btn cart-btn position-relative"
                :class="{ 'has-items': cartItemCount > 0 }"
                :disabled="cartItemCount === 0"
              >
                <i class="fas fa-shopping-cart me-2"></i>
                <span class="d-none d-sm-inline">Cart</span>
                <span v-if="cartItemCount > 0" class="cart-badge">
                  {{ cartItemCount }}
                </span>
              </button>
            </div>
          </div>
        </div>
      </nav>
    </div>
  </header>
</template>

<script setup>
defineProps({
  cartItemCount: {
    type: Number,
    default: 0
  }
})

defineEmits(['toggle-cart'])
</script>

<style scoped>
.header-main {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 1rem 0;
  box-shadow: 0 4px 20px rgba(102, 126, 234, 0.4);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.logo-icon {
  width: 56px;
  height: 56px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  color: white;
  backdrop-filter: blur(10px);
}

.brand-title {
  font-size: 1.5rem;
  font-weight: 800;
  color: white;
  letter-spacing: -0.02em;
}

.brand-subtitle {
  color: rgba(255, 255, 255, 0.8);
  font-size: 0.75rem;
  font-weight: 500;
  letter-spacing: 0.1em;
  text-transform: uppercase;
}

.nav-stats {
  color: rgba(255, 255, 255, 0.9);
  font-size: 0.875rem;
  gap: 1.5rem;
}

.stat-item {
  display: flex;
  align-items: center;
  padding: 0.5rem 1rem;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50px;
  backdrop-filter: blur(10px);
}

.cart-btn {
  background: rgba(255, 255, 255, 0.95);
  color: #667eea;
  font-weight: 600;
  padding: 0.75rem 1.5rem;
  border-radius: 50px;
  border: none;
  transition: all 0.3s ease;
}

.cart-btn:hover:not(:disabled) {
  background: white;
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.cart-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.cart-btn.has-items {
  animation: pulse 2s infinite;
}

.cart-badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: linear-gradient(135deg, #f5576c 0%, #f093fb 100%);
  color: white;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(245, 87, 108, 0.5);
}

@keyframes pulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(102, 126, 234, 0.4); }
  50% { box-shadow: 0 0 0 10px rgba(102, 126, 234, 0); }
}

@media (max-width: 768px) {
  .logo-icon {
    width: 44px;
    height: 44px;
    font-size: 1.2rem;
  }
  
  .brand-title {
    font-size: 1.2rem;
  }
  
  .cart-btn {
    padding: 0.625rem 1rem;
  }
}
</style>
