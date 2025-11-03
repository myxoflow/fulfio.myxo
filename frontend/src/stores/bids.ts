import { defineStore } from 'pinia'
import { bidsAPI } from '../api/bids'
import type { Bid } from '../types'

interface BidsState {
  bids: Bid[]
  myBids: Bid[]
  loading: boolean
  error: string | null
}

export const useBidsStore = defineStore('bids', {
  state: (): BidsState => ({
    bids: [],
    myBids: [],
    loading: false,
    error: null
  }),

  actions: {
    async fetchBids(jobId: string): Promise<void> {
      this.loading = true
      try {
        const response = await bidsAPI.getBids(jobId)
        this.bids = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch bids'
      } finally {
        this.loading = false
      }
    },

    async fetchMyBids(): Promise<void> {
      this.loading = true
      try {
        const response = await bidsAPI.getMyBids()
        this.myBids = response.data.data
      } catch (error: any) {
        this.error = 'Failed to fetch bids'
      } finally {
        this.loading = false
      }
    },

    async createBid(bidData: Partial<Bid>): Promise<void> {
      this.loading = true
      try {
        await bidsAPI.createBid(bidData)
        if (bidData.job_posting) {
          await this.fetchBids(bidData.job_posting)
        }
      } catch (error: any) {
        this.error = 'Failed to create bid'
        throw error
      } finally {
        this.loading = false
      }
    },

    async acceptBid(bidId: string): Promise<void> {
      this.loading = true
      try {
        await bidsAPI.acceptBid(bidId)
      } catch (error: any) {
        this.error = 'Failed to accept bid'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
