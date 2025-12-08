<template>
  <div class="checkout-card">
    <div class="checkout-header">
      <div class="checkout-icon">
        <i class="fas fa-credit-card"></i>
      </div>
      <h5 class="checkout-title">Complete Your Order</h5>
      <p class="checkout-subtitle">Enter your details to confirm booking</p>
    </div>
    
    <form @submit.prevent="$emit('checkout')" class="checkout-form">
      <div class="form-group">
        <label for="name" class="form-label">
          <i class="fas fa-user me-2"></i>Full Name
        </label>
        <div class="input-wrapper">
          <input 
            :value="name"
            @input="$emit('update:name', $event.target.value)"
            type="text" 
            class="form-control custom-input" 
            :class="{ 'is-valid': name && /^[A-Za-z\s]+$/.test(name), 'is-invalid': name && !/^[A-Za-z\s]+$/.test(name) }"
            id="name" 
            placeholder="Enter your full name"
            required
          >
          <span class="input-icon">
            <i class="fas fa-check text-success" v-if="name && /^[A-Za-z\s]+$/.test(name)"></i>
            <i class="fas fa-times text-danger" v-else-if="name && !/^[A-Za-z\s]+$/.test(name)"></i>
          </span>
        </div>
        <div v-if="name && !/^[A-Za-z\s]+$/.test(name)" class="error-message">
          <i class="fas fa-exclamation-circle me-1"></i>
          Name must contain only letters and spaces
        </div>
      </div>
      
      <div class="form-group">
        <label for="phone" class="form-label">
          <i class="fas fa-phone me-2"></i>Phone Number
        </label>
        <div class="input-wrapper">
          <input 
            :value="phone"
            @input="$emit('update:phone', $event.target.value)"
            type="text" 
            class="form-control custom-input"
            :class="{ 'is-valid': phone && /^[0-9]+$/.test(phone), 'is-invalid': phone && !/^[0-9]+$/.test(phone) }"
            id="phone"
            placeholder="Enter your phone number"
            required
          >
          <span class="input-icon">
            <i class="fas fa-check text-success" v-if="phone && /^[0-9]+$/.test(phone)"></i>
            <i class="fas fa-times text-danger" v-else-if="phone && !/^[0-9]+$/.test(phone)"></i>
          </span>
        </div>
        <div v-if="phone && !/^[0-9]+$/.test(phone)" class="error-message">
          <i class="fas fa-exclamation-circle me-1"></i>
          Phone must contain only numbers
        </div>
      </div>
      
      <button 
        type="submit" 
        class="btn submit-btn w-100"
        :disabled="!isValid || loading"
      >
        <span v-if="loading" class="spinner-wrapper">
          <span class="spinner-border spinner-border-sm me-2"></span>
          Processing...
        </span>
        <span v-else>
          <i class="fas fa-lock me-2"></i>
          Confirm & Pay
        </span>
      </button>
      
      <div class="security-note">
        <i class="fas fa-shield-alt me-2"></i>
        Your information is secure and encrypted
      </div>
    </form>
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

<style scoped>
.checkout-card {
  background: white;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

.checkout-header {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
  padding: 2rem;
  text-align: center;
  border-bottom: 1px solid #e2e8f0;
}

.checkout-icon {
  width: 64px;
  height: 64px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 1rem;
  font-size: 1.5rem;
  color: white;
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
}

.checkout-title {
  font-weight: 800;
  color: #1e293b;
  margin-bottom: 0.25rem;
}

.checkout-subtitle {
  color: #64748b;
  margin-bottom: 0;
  font-size: 0.875rem;
}

.checkout-form {
  padding: 2rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-label {
  font-weight: 600;
  color: #374151;
  margin-bottom: 0.5rem;
  display: block;
}

.input-wrapper {
  position: relative;
}

.custom-input {
  padding: 0.875rem 1rem;
  padding-right: 2.5rem;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.custom-input:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
}

.custom-input.is-valid {
  border-color: #10b981;
  background-color: rgba(16, 185, 129, 0.05);
}

.custom-input.is-invalid {
  border-color: #ef4444;
  background-color: rgba(239, 68, 68, 0.05);
}

.input-icon {
  position: absolute;
  right: 1rem;
  top: 50%;
  transform: translateY(-50%);
}

.error-message {
  color: #ef4444;
  font-size: 0.75rem;
  margin-top: 0.5rem;
  display: flex;
  align-items: center;
}

.submit-btn {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  border: none;
  color: white;
  font-weight: 700;
  padding: 1rem;
  border-radius: 12px;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 4px 14px rgba(17, 153, 142, 0.4);
}

.submit-btn:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(17, 153, 142, 0.5);
}

.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.spinner-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
}

.security-note {
  text-align: center;
  color: #64748b;
  font-size: 0.75rem;
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #e2e8f0;
}

@media (max-width: 768px) {
  .checkout-header {
    padding: 1.5rem;
  }
  
  .checkout-form {
    padding: 1.5rem;
  }
  
  .checkout-icon {
    width: 52px;
    height: 52px;
    font-size: 1.25rem;
  }
}
</style>
