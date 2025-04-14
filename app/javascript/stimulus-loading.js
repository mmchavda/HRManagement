export function definitionsFromContext(context) {
    return context.keys().map((key) => context(key).default)
  }
  