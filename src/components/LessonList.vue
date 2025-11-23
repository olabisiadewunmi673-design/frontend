<template>
  <div class="row">
    <div v-for="lesson in lessons" :key="lesson._id" class="col-md-4 mb-4">
      <LessonCard 
        :lesson="lesson"
        :available-spaces="getAvailableSpaces(lesson)"
        @add-to-cart="$emit('add-to-cart', $event)"
      />
    </div>
  </div>
</template>

<script setup>
import LessonCard from './LessonCard.vue'

const props = defineProps({
  lessons: {
    type: Array,
    required: true
  },
  cart: {
    type: Array,
    required: true
  }
})

defineEmits(['add-to-cart'])

const getAvailableSpaces = (lesson) => {
  const cartItem = props.cart.find(item => item._id === lesson._id)
  if (cartItem) {
    return lesson.spaces - cartItem.quantity
  }
  return lesson.spaces
}
</script>
