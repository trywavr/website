import { useRouter } from 'next/dist/client/router'
import React, { useState } from 'react'

const Demo = () => {
  const router = useRouter()
  const { stepNumber } = router.query
  const stepQueryParams = stepNumber && typeof stepNumber === 'string' ? parseInt(stepNumber) : undefined
  const [step, setStep] = useState<number>(stepQueryParams || 0)
  return (
    <div>
      {step === 0 && <h1>Demo</h1>}
      {step === 1 && <h1>Hello</h1>}
      <button onClick={() => { setStep(step + 1); router.push(`/demo?stepNumber=${step + 1}`) }}>Next</button>
    </div>
  )
}

export default Demo