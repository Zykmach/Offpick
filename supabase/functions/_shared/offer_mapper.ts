// Turns one Cuelinks offer into the JSON shape the app's OfferModel reads.
// Cuelinks offers are coupons and store deals, so they have no product price.

import { storeFor } from './stores.ts';

export type CuelinksOffer = {
  id: number | string;
  campaign: string;
  title: string;
  description?: string;
  terms_and_condition?: string;
  coupon_code?: string;
  status?: string;
  url?: string;
  start_date?: string;
  end_date?: string;
  // The live API sends this as text like "{'1': 'Fashion'}".
  categories?: Record<string, string> | string[] | string;
};

// [subcategory id, category id, icon, words that point to it]. First match wins.
const subcategoryWords: [string, string, string, string[]][] = [
  ['mobiles-smartwatch', 'mobiles', 'watch', ['smartwatch', 'smart watch']],
  ['mobiles-earbuds', 'mobiles', 'headphones', ['earbud', 'airdopes', 'tws', 'neckband']],
  ['mobiles-powerbanks', 'mobiles', 'battery', ['power bank', 'powerbank']],
  ['mobiles-tablets', 'mobiles', 'tablet', ['tablet', 'ipad']],
  ['mobiles-accessories', 'mobiles', 'cable', ['charger', 'cable', 'mobile cover', 'phone case']],
  ['electronics-laptop', 'electronics', 'laptop', ['laptop', 'notebook']],
  ['electronics-tv', 'electronics', 'tv', ['television', ' tv', 'smart tv']],
  ['electronics-camera', 'electronics', 'camera', ['camera', 'dslr']],
  ['electronics-audio', 'electronics', 'headphones', ['headphone', 'speaker', 'soundbar', 'audio']],
  ['mobiles-phones', 'mobiles', 'phone', ['smartphone', 'mobile', 'phone', 'iphone']],
  ['beauty-fragrance', 'beauty', 'spray', ['perfume', 'fragrance', 'deo']],
  ['beauty-haircare', 'beauty', 'droplet', ['shampoo', 'hair']],
  ['beauty-makeup', 'beauty', 'palette', ['makeup', 'lipstick', 'foundation', 'kajal', 'nail']],
  ['beauty-skincare', 'beauty', 'droplet', ['skin', 'sunscreen', 'serum', 'face wash', 'moisturi']],
  ['women-kurtis', 'fashion', 'shirt', ['kurti', 'saree', 'lehenga']],
  ['women-handbags', 'fashion', 'handbag', ['handbag', 'tote', 'sling bag', 'clutch']],
  ['women-jewellery', 'fashion', 'gem', ['jewel', 'pendant', 'earring', 'necklace']],
  ['women-footwear', 'fashion', 'shoe', ['sandal', 'heels', 'flats']],
  ['men-tshirts', 'fashion', 'tshirt', ['t-shirt', 'tshirt', 'tee']],
  ['men-shirts', 'fashion', 'shirt', ['shirt']],
  ['men-jeans', 'fashion', 'jeans', ['jean', 'denim', 'trouser']],
  ['men-shoes', 'fashion', 'shoe', ['shoe', 'sneaker', 'footwear']],
  ['men-watches', 'fashion', 'watch', ['watch']],
  ['women-tops', 'fashion', 'shirt', ['dress', 'women']],
];

// Used when no product word matches: [category id, icon, words].
const categoryWords: [string, string, string[]][] = [
  ['beauty', 'sparkles', ['beauty', 'cosmetic', 'personal care', 'grooming', 'makeup', 'health']],
  ['mobiles', 'phone', ['mobile', 'gadget', 'tablet']],
  ['electronics', 'laptop', ['electronic', 'appliance', 'computer']],
  ['fashion', 'shirt', ['fashion', 'cloth', 'apparel', 'lifestyle', 'footwear', 'accessor']],
];

const tints = ['green', 'blue', 'peach', 'pink'];
const dayMs = 24 * 60 * 60 * 1000;

export function mapOffer(offer: CuelinksOffer) {
  if (!offer.campaign || !offer.title || !offer.url) return null;
  const store = storeFor(offer.campaign);
  const offerId = Number(offer.id);
  if (offer.status && offer.status !== 'live') return null;

  const startsAt = toDate(offer.start_date, 'T00:00:00+05:30') ?? new Date();
  const endsAt = toDate(offer.end_date, 'T23:59:59+05:30') ?? new Date(Date.now() + 30 * dayMs);
  if (endsAt.getTime() < Date.now()) return null;

  const categoryNames = categoryNamesOf(offer.categories);
  const text = ` ${offer.title} ${offer.description ?? ''} ${categoryNames.join(' ')} `.toLowerCase();
  const subcategory = subcategoryWords.find(([, , , words]) => words.some((word) => text.includes(word)));
  const category = categoryWords.find(([, , words]) => words.some((word) => text.includes(word)));

  const subcategoryId = subcategory?.[0] ?? '';
  const percent = `${offer.title} ${offer.description ?? ''}`.match(/(\d{1,2})\s*%/);

  return {
    id: `cl-${offer.id}`,
    brand: store.name,
    title: cleanText(offer.title),
    storeId: store.id,
    storeName: store.name,
    price: null,
    mrp: null,
    discount: percent ? Number(percent[1]) : 0,
    couponCode: offer.coupon_code?.trim() ?? '',
    description: cleanText(offer.description ?? ''),
    terms: cleanText(offer.terms_and_condition ?? ''),
    url: offer.url ?? '',
    startedAt: startsAt.toISOString(),
    endsAt: endsAt.toISOString(),
    categoryId: subcategory?.[1] ?? category?.[0] ?? '',
    subcategoryId,
    groupId: subcategoryId.startsWith('men-') ? 'men' : subcategoryId.startsWith('women-') ? 'women' : '',
    icon: subcategory?.[2] ?? category?.[1] ?? 'tag',
    tint: tints[offerId % tints.length] ?? tints[0],
    isNew: Date.now() - startsAt.getTime() < 2 * dayMs,
  };
}

function categoryNamesOf(categories: CuelinksOffer['categories']): string[] {
  if (!categories) return [];
  if (Array.isArray(categories)) return categories;
  if (typeof categories === 'string') {
    return [...categories.matchAll(/:\s*'([^']*)'/g)].map((match) => match[1]);
  }
  return Object.values(categories);
}

/// "2026-10-25" -> that day in India time. Full timestamps are used as they are.
function toDate(value: string | undefined, timeOfDay: string): Date | null {
  if (!value) return null;
  const date = new Date(value.length === 10 ? `${value}${timeOfDay}` : value);
  return Number.isNaN(date.getTime()) ? null : date;
}

function cleanText(value: string) {
  return value.replace(/<[^>]*>/g, ' ').replace(/&nbsp;/g, ' ').replace(/&amp;/g, '&').replace(/\s+/g, ' ').trim();
}
