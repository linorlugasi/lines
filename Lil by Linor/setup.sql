-- =============================================
-- Lil by Linor — Database Setup
-- הרץ את זה פעם אחת ב-Supabase SQL Editor
-- =============================================

-- 1. טבלת הזמנות
CREATE TABLE IF NOT EXISTS public.bookings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_name TEXT NOT NULL,
  client_phone TEXT NOT NULL,
  service TEXT NOT NULL,
  booking_date DATE NOT NULL,
  booking_time TIME NOT NULL,
  notes TEXT DEFAULT '',
  status TEXT DEFAULT 'confirmed',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. טבלת חסימות (שעות/ימים חסומים)
CREATE TABLE IF NOT EXISTS public.blocked_slots (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  blocked_date DATE NOT NULL,
  blocked_time TIME DEFAULT NULL, -- NULL = כל היום חסום
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. טבלת שעות עבודה
CREATE TABLE IF NOT EXISTS public.working_hours (
  day_of_week INTEGER PRIMARY KEY, -- 0=ראשון, 1=שני, ... 6=שבת
  is_working BOOLEAN DEFAULT TRUE,
  start_hour INTEGER DEFAULT 9,
  end_hour INTEGER DEFAULT 19
);

-- 4. טבלת הגדרות (כולל סיסמת מנהל)
CREATE TABLE IF NOT EXISTS public.settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

-- 5. שעות עבודה ברירת מחדל
INSERT INTO public.working_hours (day_of_week, is_working, start_hour, end_hour) VALUES
  (0, false, 9, 19),
  (1, true,  9, 19),
  (2, true,  9, 19),
  (3, true,  9, 19),
  (4, true,  9, 19),
  (5, true,  9, 17),
  (6, false, 9, 14)
ON CONFLICT (day_of_week) DO NOTHING;

-- 6. פרטי כניסה למנהל (שם משתמש: linor, סיסמא: linor2025)
INSERT INTO public.settings (key, value) VALUES
  ('admin_username', 'linor'),
  ('admin_password', 'linor2025')
ON CONFLICT (key) DO NOTHING;

-- 7. הרשאות גישה
ALTER TABLE public.bookings DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.blocked_slots DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.working_hours DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.settings DISABLE ROW LEVEL SECURITY;

GRANT ALL ON public.bookings TO anon, authenticated;
GRANT ALL ON public.blocked_slots TO anon, authenticated;
GRANT ALL ON public.working_hours TO anon, authenticated;
GRANT ALL ON public.settings TO anon, authenticated;
