describe 'utils', ->
  describe 'string utilities', ->

    testStr = 'Testing123'

    beforeEach module 'app'

    it 'should verify that [startsWith] utility function is in place', () ->
      expect(typeof String.prototype.startsWith).toBeDefined()

    it 'should verify that [endsWith] utility function is in place', () ->
      expect(typeof String.prototype.endsWith).toBeDefined()

    it 'should verify operation of [startsWith] utility function', () ->
      expect(testStr.startsWith('T')).toBeTruthy()
      expect(testStr.startsWith('T-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-T-xxx')).toBeFalsy()
      expect(testStr.startsWith('Te')).toBeTruthy()
      expect(testStr.startsWith('Te-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Te-xxx')).toBeFalsy()
      expect(testStr.startsWith('Tes')).toBeTruthy()
      expect(testStr.startsWith('Tes-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Tes-xxx')).toBeFalsy()
      expect(testStr.startsWith('Test')).toBeTruthy()
      expect(testStr.startsWith('Test-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Test-xxx')).toBeFalsy()
      expect(testStr.startsWith('Testi')).toBeTruthy()
      expect(testStr.startsWith('Testi-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Testi-xxx')).toBeFalsy()
      expect(testStr.startsWith('Testin')).toBeTruthy()
      expect(testStr.startsWith('Testin-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Testin-xxx')).toBeFalsy()
      expect(testStr.startsWith('Testing')).toBeTruthy()
      expect(testStr.startsWith('Testing-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Testing-xxx')).toBeFalsy()
      expect(testStr.startsWith('Testing1')).toBeTruthy()
      expect(testStr.startsWith('Testing1-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Testing1-xxx')).toBeFalsy()
      expect(testStr.startsWith('Testing12')).toBeTruthy()
      expect(testStr.startsWith('Testing12-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Testing12-xxx')).toBeFalsy()
      expect(testStr.startsWith('Testing123')).toBeTruthy()
      expect(testStr.startsWith('Testing123-xxx')).toBeFalsy()
      expect(testStr.startsWith('xx-Testing123-xxx')).toBeFalsy()

    it 'should verify operation of [endsWith] utility function', () ->
      expect(testStr.endsWith('x-3')).toBeFalsy()
      expect(testStr.endsWith('3-x')).toBeFalsy()
      expect(testStr.endsWith('3')).toBeTruthy()
      expect(testStr.endsWith('x-23')).toBeFalsy()
      expect(testStr.endsWith('23-x')).toBeFalsy()
      expect(testStr.endsWith('23')).toBeTruthy()
      expect(testStr.endsWith('x-123')).toBeFalsy()
      expect(testStr.endsWith('123-x')).toBeFalsy()
      expect(testStr.endsWith('123')).toBeTruthy()
      expect(testStr.endsWith('x-g123')).toBeFalsy()
      expect(testStr.endsWith('g123-x')).toBeFalsy()
      expect(testStr.endsWith('g123')).toBeTruthy()
      expect(testStr.endsWith('x-ng123')).toBeFalsy()
      expect(testStr.endsWith('ng123-x')).toBeFalsy()
      expect(testStr.endsWith('ng123')).toBeTruthy()
      expect(testStr.endsWith('x-ing123')).toBeFalsy()
      expect(testStr.endsWith('ing123-x')).toBeFalsy()
      expect(testStr.endsWith('ing123')).toBeTruthy()
      expect(testStr.endsWith('x-ting123')).toBeFalsy()
      expect(testStr.endsWith('ting123-x')).toBeFalsy()
      expect(testStr.endsWith('ting123')).toBeTruthy()
      expect(testStr.endsWith('x-ting123')).toBeFalsy()
      expect(testStr.endsWith('ting123-x')).toBeFalsy()
      expect(testStr.endsWith('ting123')).toBeTruthy()
      expect(testStr.endsWith('x-sting123')).toBeFalsy()
      expect(testStr.endsWith('sting123-x')).toBeFalsy()
      expect(testStr.endsWith('sting123')).toBeTruthy()
      expect(testStr.endsWith('x-esting123')).toBeFalsy()
      expect(testStr.endsWith('esting123-x')).toBeFalsy()
      expect(testStr.endsWith('esting123')).toBeTruthy()
      expect(testStr.endsWith('x-Testing123')).toBeFalsy()
      expect(testStr.endsWith('Testing123-x')).toBeFalsy()
      expect(testStr.endsWith('Testing123')).toBeTruthy()


