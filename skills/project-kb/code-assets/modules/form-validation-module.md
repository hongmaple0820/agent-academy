---
id: "module-form-validation"
type: "validation"
complexity: "medium"
title: "表单验证模块"
description: "类型安全的表单验证系统，支持同步/异步验证、字段级验证和自定义规则"
author: "ChessVerse"
---

# 表单验证模块

## 概述

提供完整的表单验证解决方案：
- 声明式验证规则
- 同步和异步验证
- 字段级验证
- 自定义验证规则
- React Hook 集成

## 接口定义

### 核心类型

```typescript
// 验证结果
type ValidationResult = {
  valid: boolean;
  errors: Record<string, string>;
};

// 验证规则
type ValidationRule<T = any> = {
  required?: boolean;
  minLength?: number;
  maxLength?: number;
  min?: number;
  max?: number;
  pattern?: RegExp;
  email?: boolean;
  url?: boolean;
  match?: string; // 匹配另一个字段
  custom?: (value: T, formData: any) => boolean | Promise<boolean>;
  message?: string;
};

// 验证模式
type ValidationSchema<T extends Record<string, any>> = {
  [K in keyof T]?: ValidationRule<T[K]>;
};

// 字段状态
type FieldState = {
  value: any;
  error: string | null;
  touched: boolean;
  dirty: boolean;
  validating: boolean;
};

// 表单状态
type FormState<T> = {
  values: T;
  errors: Record<string, string>;
  touched: Record<string, boolean>;
  isValid: boolean;
  isSubmitting: boolean;
  isDirty: boolean;
};
```

### 验证器接口

```typescript
interface IValidator<T extends Record<string, any>> {
  // 验证整个表单
  validate(values: T): Promise<ValidationResult>;
  
  // 验证单个字段
  validateField(
    field: keyof T,
    value: any,
    formData: T
  ): Promise<string | null>;
  
  // 获取字段规则
  getRules(): ValidationSchema<T>;
}
```

## 核心实现

### 1. 验证器类

```typescript
// lib/validator.ts
export class Validator<T extends Record<string, any>> {
  constructor(private schema: ValidationSchema<T>) {}

  async validate(values: T): Promise<ValidationResult> {
    const errors: Record<string, string> = {};

    for (const [key, rule] of Object.entries(this.schema)) {
      if (rule) {
        const error = await this.validateField(key as keyof T, values[key], values);
        if (error) {
          errors[key] = error;
        }
      }
    }

    return {
      valid: Object.keys(errors).length === 0,
      errors
    };
  }

  async validateField(
    field: keyof T,
    value: any,
    formData: T
  ): Promise<string | null> {
    const rule = this.schema[field];
    if (!rule) return null;

    const fieldName = String(field);

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

    // 字段匹配
    if (rule.match && formData[rule.match] !== value) {
      return rule.message || `${fieldName} 与 ${rule.match} 不匹配`;
    }

    // 自定义验证
    if (rule.custom) {
      const isValid = await rule.custom(value, formData);
      if (!isValid) {
        return rule.message || `${fieldName} 验证失败`;
      }
    }

    return null;
  }
}
```

### 2. React Hook

```typescript
// hooks/use-form.ts
import { useState, useCallback, useEffect } from 'react';
import { Validator } from '@/lib/validator';

export function useForm<T extends Record<string, any>>(
  initialValues: T,
  schema: ValidationSchema<T>,
  onSubmit: (values: T) => Promise<void>
) {
  const [values, setValues] = useState<T>(initialValues);
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [touched, setTouched] = useState<Record<string, boolean>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isDirty, setIsDirty] = useState(false);

  const validator = new Validator(schema);

  const validateField = useCallback(
    async (field: keyof T, value: any) => {
      const error = await validator.validateField(field, value, values);
      setErrors(prev => ({ ...prev, [field]: error || '' }));
      return error;
    },
    [values, validator]
  );

  const setFieldValue = useCallback(
    async (field: keyof T, value: any) => {
      setValues(prev => ({ ...prev, [field]: value }));
      setIsDirty(true);
      
      if (touched[field]) {
        await validateField(field, value);
      }
    },
    [touched, validateField]
  );

  const setFieldTouched = useCallback(
    async (field: keyof T, isTouched = true) => {
      setTouched(prev => ({ ...prev, [field]: isTouched }));
      if (isTouched) {
        await validateField(field, values[field]);
      }
    },
    [values, validateField]
  );

  const validateForm = useCallback(async () => {
    const result = await validator.validate(values);
    setErrors(result.errors);
    return result.valid;
  }, [values, validator]);

  const handleSubmit = useCallback(
    async (e?: React.FormEvent) => {
      e?.preventDefault();
      
      // 标记所有字段为 touched
      const allTouched = Object.keys(schema).reduce(
        (acc, key) => ({ ...acc, [key]: true }),
        {}
      );
      setTouched(allTouched);

      const isValid = await validateForm();
      if (!isValid) return;

      setIsSubmitting(true);
      try {
        await onSubmit(values);
      } finally {
        setIsSubmitting(false);
      }
    },
    [values, validateForm, onSubmit, schema]
  );

  const reset = useCallback(() => {
    setValues(initialValues);
    setErrors({});
    setTouched({});
    setIsDirty(false);
  }, [initialValues]);

  return {
    values,
    errors,
    touched,
    isSubmitting,
    isDirty,
    isValid: Object.keys(errors).length === 0,
    setFieldValue,
    setFieldTouched,
    handleSubmit,
    reset,
  };
}
```

## 使用示例

```tsx
// 注册表单
function RegisterForm() {
  const form = useForm(
    { username: '', email: '', password: '', confirmPassword: '' },
    {
      username: { required: true, minLength: 3, maxLength: 20 },
      email: { required: true, email: true },
      password: { required: true, minLength: 8 },
      confirmPassword: { 
        required: true, 
        match: 'password',
        message: '密码不匹配'
      }
    },
    async (values) => {
      await api.register(values);
      toast.success('注册成功');
    }
  );

  return (
    <form onSubmit={form.handleSubmit}>
      <div>
        <input
          value={form.values.username}
          onChange={e => form.setFieldValue('username', e.target.value)}
          onBlur={() => form.setFieldTouched('username')}
          placeholder="用户名"
        />
        {form.touched.username && form.errors.username && (
          <span className="error">{form.errors.username}</span>
        )}
      </div>

      <div>
        <input
          type="email"
          value={form.values.email}
          onChange={e => form.setFieldValue('email', e.target.value)}
          onBlur={() => form.setFieldTouched('email')}
          placeholder="邮箱"
        />
        {form.touched.email && form.errors.email && (
          <span className="error">{form.errors.email}</span>
        )}
      </div>

      <div>
        <input
          type="password"
          value={form.values.password}
          onChange={e => form.setFieldValue('password', e.target.value)}
          onBlur={() => form.setFieldTouched('password')}
          placeholder="密码"
        />
        {form.touched.password && form.errors.password && (
          <span className="error">{form.errors.password}</span>
        )}
      </div>

      <div>
        <input
          type="password"
          value={form.values.confirmPassword}
          onChange={e => form.setFieldValue('confirmPassword', e.target.value)}
          onBlur={() => form.setFieldTouched('confirmPassword')}
          placeholder="确认密码"
        />
        {form.touched.confirmPassword && form.errors.confirmPassword && (
          <span className="error">{form.errors.confirmPassword}</span>
        )}
      </div>

      <button type="submit" disabled={form.isSubmitting}>
        {form.isSubmitting ? '提交中...' : '注册'}
      </button>
    </form>
  );
}
```

## 测试用例

```typescript
// __tests__/validation.test.ts
import { Validator } from '@/lib/validator';

describe('Form Validation', () => {
  const validator = new Validator({
    username: { required: true, minLength: 3 },
    email: { required: true, email: true },
    age: { min: 0, max: 150 }
  });

  it('should validate required fields', async () => {
    const result = await validator.validate({ username: '', email: '' });
    expect(result.valid).toBe(false);
    expect(result.errors.username).toBeDefined();
  });

  it('should validate email format', async () => {
    const result = await validator.validate({ 
      username: 'test', 
      email: 'invalid-email' 
    });
    expect(result.errors.email).toBeDefined();
  });

  it('should pass valid data', async () => {
    const result = await validator.validate({
      username: 'testuser',
      email: 'test@example.com',
      age: 25
    });
    expect(result.valid).toBe(true);
  });

  it('should validate min/max', async () => {
    const result = await validator.validate({
      username: 'test',
      email: 'test@example.com',
      age: 200
    });
    expect(result.errors.age).toBeDefined();
  });
});
```

## 设计思路

1. **声明式**: 通过 schema 定义验证规则，清晰直观
2. **渐进式验证**: 支持字段级验证和整体验证
3. **异步支持**: 自定义验证规则支持异步操作
4. **React 集成**: 提供完整的 Hook，管理表单状态
5. **类型安全**: 完整的 TypeScript 支持
