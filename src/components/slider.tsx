import * as SliderPrimitive from '@radix-ui/react-slider';

export const Slider = () => (
  <SliderPrimitive.Root>
    <SliderPrimitive.Track>
      <SliderPrimitive.Range />
    </SliderPrimitive.Track>
    <SliderPrimitive.Thumb />
  </SliderPrimitive.Root>
);
