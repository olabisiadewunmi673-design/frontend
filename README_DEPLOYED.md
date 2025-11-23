# Deployment Information

## 🚀 Live URLs

- **Frontend (GitHub Pages)**: https://olabisiadewunmi673-design.github.io/frontend/
- **Backend (Render.com)**: https://ola-cousework.onrender.com
- **GitHub Repository**: https://github.com/olabisiadewunmi673-design/frontend

## 📦 Project Structure

The Vue 3 frontend is now organized with separate components:

```
src/
├── App.vue                 # Main app component
├── components/
│   ├── Header.vue         # Navigation header with cart button
│   ├── Alert.vue          # Success/error message display
│   ├── SearchBar.vue      # Search input component
│   ├── SortControls.vue   # Sorting buttons
│   ├── LessonList.vue     # Container for lesson cards
│   ├── LessonCard.vue     # Individual lesson card
│   ├── Cart.vue           # Shopping cart view
│   └── Checkout.vue       # Checkout form component
└── main.js                # App entry point
```

## 🔄 Deployment Process

### Automatic Deployment (GitHub Actions)
Every push to the `main` branch automatically deploys to GitHub Pages via the workflow in `.github/workflows/deploy.yml`

### Manual Deployment
```bash
# Build and deploy to gh-pages branch
npm run build
./deploy.sh
```

## 🛠️ Local Development

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build
```

## 🔧 Environment Configuration

- **Production**: Uses Render backend at `https://ola-cousework.onrender.com`
- **Local Development**: Create `.env.local` with `VITE_API_URL=http://localhost:3000`

## ✅ Features Implemented

- ✨ Component-based architecture with Vue 3 Composition API
- 📱 Responsive design with Bootstrap 5
- 🔍 Real-time search across all fields
- 🔢 Multi-criteria sorting with direction toggle
- 🛒 Shopping cart with quantity management
- ✅ Form validation with regex patterns
- 🚀 Optimized production build with Vite
- 📦 Automatic deployment to GitHub Pages

## 📊 API Integration

All API calls use native `fetch()` (no axios) to communicate with the backend:
- GET `/lessons` - Fetch all lessons
- GET `/lessons/:id` - Get single lesson
- POST `/orders` - Create order
- PUT `/lessons/:id` - Update lesson spaces
- GET `/search?q=` - Search lessons

## 🎨 Component Details

### LessonCard.vue
- Displays individual lesson with image/icon
- Shows subject, location, price, and available spaces
- Add to cart button with disabled state when full

### Cart.vue
- Manages cart items with quantity controls
- Calculates total price
- Contains checkout form via Checkout component

### Checkout.vue
- Name validation (letters only)
- Phone validation (numbers only)
- Form submission handling

### SearchBar.vue & SortControls.vue
- Reusable search and sort components
- Two-way binding with v-model

## 🔐 Security

- Environment variables for API URL
- Input validation on both frontend and backend
- CORS configured for cross-origin requests
