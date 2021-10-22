import { css, styled } from '../../stitches.config';

export const panelStyles = css({
  backgroundColor: '$mauve1',
  borderRadius: '$2',
  boxShadow: '$colors$mauveA6 0px 10px 38px -10px, $colors$mauveA12 0px 10px 20px -15px',
  padding: '$4',
});

export const Panel = styled('div', panelStyles);