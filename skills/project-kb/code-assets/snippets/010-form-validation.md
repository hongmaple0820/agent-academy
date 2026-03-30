---
id: "snippet-010"
language: "typescript"
category: "data-processing"
tags: ["validation", "form", "schema", "type-safe"]
author: "ChessVerse"
description: "类型安全的表单验证工具，支持多种验证规则和自定义错误消息"
complexity: "medium"
---

# 表单验证工具

## 代码内容

```typescript
/**
 * 验证结果类型
 */
type ValidationResult = {
  valid: boolean;
  errors: Record<string, string>;
};

/**
 * 验证规则类型
 */
type ValidationRule<T = any> = {
  required?: boolean;
  minLength?: number;
  maxLength?: number;
  min?: number;
  max?: number;
  pattern?: RegExp;
  email?: boolean;
  url?: boolean;
  custom?: (value: T) => boolean;
  message?: string;
};

/**
 * 验证模式
 */
type ValidationSchema<T extends Record<string, any>> = {
  [K in keyof T]?: ValidationRule<T[K]>;
};

/**
 * 验证单个值
 */
function validateValue<T>(
  value: T,
  rule: ValidationRule<T>,
  fieldName: string
): string | null {
  // 必填检查
  if (rule.required && (value === undefined || value === null || value === '')) {
    return rule.message || `${fieldName} 不能为空`;
  }

  if (value === undefined || value === null || value === '') {
    return null;
  }

  const strValue = String(value);

  // 最小长度
  if (rule.minLength !== undefined && strValue.length < rule.minLength) {
    return rule.message || `${fieldName} 至少需要 ${rule.minLength} 个字符`;
  }

  // 最大长度
  if (rule.maxLength !== undefined && strValue.length > rule.maxLength) {
    return rule.message || `${fieldName} 最多 ${rule.maxLength} 个字符`;
  }

  // 最小值
  if (rule.min !== undefined && Number(value) < rule.min) {
    return rule.message || `${fieldName} 不能小于 ${rule.min}`;
  }

  // 最大值
  if (rule.max !== undefined && Number(value) > rule.max) {
    return rule.message || `${fieldName} 不能大于 ${rule.max}`;
  }

  // 正则匹配
  if (rule.pattern && !rule.pattern.test(strValue)) {
    return rule.message || `${fieldName} 格式不正确`;
  }

  // 邮箱验证
  if (rule.email) {
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(strValue)) {
      return rule.message || `${fieldName} 邮箱格式不正确`;
    }
  }

  // URL 验证
  if (rule.url) {
    try {
      new URL(strValue);
    } catch {
      return rule.message || `${fieldName} URL 格式不正确`;
    }
  }

  // 自定义验证
  if (rule.custom && !rule.custom(value)) {
    return rule.message || `${fieldName} 验证失败`;
  }

  return null;
}

/**
 * 验证对象
 */
export function validate<T extends Record<string, any>>(
  data: T,
  schema: ValidationSchema<T>
): ValidationResult {
  const errors: Record<string, string> = {};

  for (const [key, rule] of Object.entries(schema)) {
    if (rule) {
      const error = validateValue(data[key], rule as ValidationRule, String(key));
      if (error) {
        errors[key] = error;
      }
    }
  }

  return {
    valid: Object.keys(errors).length === 0,
    errors,
  };
}

/**
 * 创建验证器
 */
export function createValidator<T extends Record<string, any>>(
  schema: ValidationSchema<T>
) {
  return {
    validate: (data: T) => validate(data, schema),
    validateField: (data: T, field: keyof T) => {
      const rule = schema[field];
      if (!rule) return null;
      return validateValue(data[field], rule as ValidationRule, String(field));
    },
  };
}

/**
 * 常用验证规则预设
 */
export const validators = {
  required: (message?: string): ValidationRule => ({ required: true, message }),
  email: (message?: string): ValidationRule => ({ email: true, message }),
  url: (message?: string): ValidationRule => ({ url: true, message }),
  minLength: (min: number, message?: string): ValidationRule => ({ minLength: min, message }),
  maxLength: (max: number, message?: string): ValidationRule => ({ maxLength: max, message }),
  range: (min: number, max: number, message?: string): ValidationRule => ({ min, max, message }),
  pattern: (regex: RegExp, message?: string): ValidationRule => ({ pattern: regex, message }),
  custom: <T>(fn: (value: T) => boolean, message?: string): ValidationRule<T> => ({ custom: fn, message }),
};
```

## 使用示例

```typescript
import { validate, createValidator, validators } from "@/lib/validation"

// 直接验证
const result = validate(
  { email: "test@example.com", password: "123456" },
  {
    email: { required: true, email: true },
    password: { required: true, minLength: 6 },
  }
)

if (!result.valid) {
  console.log(result.errors) // { password: "password 至少需要 6 个字符" }
}

// 创建可复用的验证器
const userValidator = createValidator({
  username: { required: true, minLength: 3, maxLength: 20 },
  email: { required: true, email: true },
  age: { min: 0, max: 150 },
  website: { url: true },
})

// 使用预设规则
const loginValidator = createValidator({
  email: validators.email("请输入有效的邮箱"),
  password: validators.minLength(8, "密码至少8位"),
})

// React Hook 示例
function useFormValidation<T extends Record<string, any>>(schema: ValidationSchema<T>) {
  const [errors, setErrors] = useState<Record<string, string>>({})
  
  const validateForm = (data: T) => {
    const result = validate(data, schema)
    setErrors(result.errors)
    return result.valid
  }
  
  return { errors, validateForm }
}
```
